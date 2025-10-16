#include <gtk/gtk.h>
#include <librsvg/rsvg.h>
#include <sys/time.h>
#include <math.h>
#include <getopt.h>
#include <fontconfig/fontconfig.h>

GtkStatusIcon* tray;
static int icon_size = 32;
static int no_tooltip = 0;
static int update_interval = 200;
char *version="0.1.5";
static int coco = 0;
static guint timer_id = 0;


void arguments(const int argc, char* argv[])
{
    int opt;
    const struct option options[] = {
        {"size", required_argument, NULL, 's'},
        {"utime", required_argument, NULL, 'u'},
        {"help", no_argument, NULL, 'h'},
        {"version", no_argument, NULL, 'v'},
        {"soft", no_argument, NULL, 'f'},
        {"no-tooltip", no_argument, NULL, 'n'},
        {NULL, 0, NULL, 0}
    };

    while ((opt = getopt_long(argc, argv, "s:u:hvfn", options, NULL)) != -1)
    {
        switch (opt)
        {
        case 's':
            if (!optarg)
            {
                fprintf(stderr, "Error: Missing value for -size.\n");
                exit(1);
            }
            icon_size = atoi(optarg);
            g_printerr("Warning: this option may not work!");
            if (icon_size < 16 || icon_size > 128)
            {
                fprintf(stderr, "Error: Icon size must be between 16 and 128.\n");
                exit(1);
            }
            break;
        case 'f':
            coco = 1;
            break;
        case 'n':
            no_tooltip = 1;
            break;
        case 'u':
            if (!optarg)
            {
                fprintf(stderr, "Error: Missing value for -utime.\n");
                exit(1);
            }
            update_interval = atoi(optarg);
            if (update_interval < 100 || update_interval > 1000)
            {
                fprintf(stderr, "Error: Update interval must be between 100 and 1000 milliseconds.\n");
                exit(1);
            }
            break;
        case 'h':
            printf("Usage: %s [--size <icon_size>] [--utime <milliseconds>] [-h] [-v] [-f] [-n]\n", argv[0]);
            printf("Options:\n");
            printf("  -size <pixel>             Icon size (16 - 128). Default is 32.\n");
            printf("  -utime <milliseconds>     Update interval for soft mode (100 - 1000). Default is 500.\n");
            printf("  -h, --help                Show this help message.\n");
            printf("  -v, --version             Show version.\n");
            printf("  -f, --soft                Enable soft mod.\n");
            printf("  -n, --no-tooltip          Disable tooltip.\n\n");
            printf("                Credit : VC365 (https://github.com/VC365) \n\n");
            exit(0);
        case 'v':
            printf("VC Clock %s",version);
            exit(0);
        default:
            fprintf(stderr, "Invalid argument. Use -h or --help for usage info.\n");
            exit(1);
        }
    }
}

void svg(char* buffer, size_t bufsize, const int size)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);

    const struct tm* tm = localtime(&tv.tv_sec);

    double secondsX = tm->tm_sec + (coco ? tv.tv_usec / 1000000.0 : 0);
    double total_seconds = tm->tm_hour * 3600.0 + tm->tm_min * 60.0 + secondsX;

    double hour = fmod(total_seconds / 43200.0 * 360.0, 360.0);
    double minute = fmod(total_seconds / 3600.0 * 360.0, 360.0);
    double second = fmod(secondsX * 6.0, 360.0);


    snprintf(buffer, bufsize,
             "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"%d\" height=\"%d\" viewBox=\"0 0 16 16\">"
             "<circle cx=\"8\" cy=\"8\" r=\"7\" stroke=\"#ddd\" stroke-width=\"2\" fill=\"none\"/>"
             "<g transform=\"rotate(%.6f 8 8)\">"
             "<line x1=\"8\" y1=\"8\" x2=\"8\" y2=\"4.8\" stroke=\"#ffffff\" stroke-width=\"1.2\" stroke-linecap=\"round\"/>"
             "</g><g transform=\"rotate(%.6f 8 8)\">"
             "<line x1=\"8\" y1=\"8\" x2=\"8\" y2=\"3.3\" stroke=\"#cccccc\" stroke-width=\"0.9\" stroke-linecap=\"round\"/>"
             "</g><g transform=\"rotate(%.6f 8 8)\">"
             "<line x1=\"8\" y1=\"8\" x2=\"8\" y2=\"2.3\" stroke=\"#aaaaaa\" stroke-width=\"0.6\" stroke-linecap=\"round\"/>"
             "</g><circle cx=\"8\" cy=\"8\" r=\"0.6\" fill=\"#fff\"/></svg>",
             size, size,
             hour,
             minute,
             second
    );
}

static void update_timer(const GSourceFunc dood){
    struct timeval current_time;
    int milliseconds = 1000;

    if (gettimeofday(&current_time, NULL) >= 0)
        milliseconds -= current_time.tv_usec / 1000;


    if (milliseconds <= 0)
        milliseconds = 1000;

    if (timer_id != 0)
    {
        g_source_remove(timer_id);
        timer_id = 0;
    }

    timer_id = g_timeout_add(milliseconds, dood, NULL);
}

gboolean update_tooltip(gpointer data)
{
    if (no_tooltip){return 0;}

    char tooltip[64];
    strftime(tooltip, sizeof(tooltip), "%H:%M:%S", localtime(&(time_t){time(NULL)}));
    gtk_status_icon_set_tooltip_text(tray, tooltip);
    if (coco)
        update_timer(update_tooltip);

    return 0;
}

gboolean update_icon(gpointer data)
{
    static char svg_data[2048];
    svg(svg_data, sizeof(svg_data), icon_size);

    GError* error = NULL;
    RsvgHandle* handle = rsvg_handle_new_from_data((const guint8*)svg_data, strlen(svg_data), &error);
    if (!handle)
    {
        g_printerr("Error creating RsvgHandle: %s\n", error->message);
        g_clear_error(&error);
        return TRUE;
    }

    GdkPixbuf* pixbuf = rsvg_handle_get_pixbuf(handle);
    if (pixbuf)
    {
        gtk_status_icon_set_from_pixbuf(tray, pixbuf);
        g_object_unref(pixbuf);
        if (!coco)update_tooltip(NULL);
    }
    else
    {
        g_printerr("Error converting SVG to Pixbuf\n");
    }

    g_object_unref(handle);

    if (!coco)
    {
        update_timer(update_icon);
        return 0;
    }
    return 1;
}

int main(int argc, char** argv)
{
    arguments(argc, argv);
    gtk_init(&argc, &argv);
    FcInit();

    tray = gtk_status_icon_new();
    gtk_status_icon_set_visible(tray, TRUE);

    if (coco)
    {
        g_timeout_add(update_interval, (GSourceFunc)update_icon, NULL);
        if (!no_tooltip)update_timer(update_tooltip);
    }
    else
        update_timer(update_icon);

    gtk_main();
    return 0;
}
