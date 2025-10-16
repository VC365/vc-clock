require "option_parser"
require "./lib/Xlib"

def arguments
    OptionParser.parse do |arg|
        arg.banner="Usage: vc-clock [--size <icon_size>] [--utime <milliseconds>] [-h] [-v] [-f] [-n]\n Options:"
        arg.on("--size PIXEL","Icon size (16 - 128). Default is 32.") do |val|
            Xlib.icon_size=(val.to_i? || 32).clamp(16, 128)
        end
        arg.on("--utime MILLISECONDS","Update interval for soft mode (100 - 1000). Default is #{Xlib.interval}.") do |val|
            Xlib.interval=(val.to_i? || 450).clamp(100, 1000)
        end
        arg.on("-n","--no-tooltip","Disable tooltip.") do
            Xlib.tooltip=false
        end
        arg.on("-f","--soft","Enable soft mod.") do
            Xlib.soft=true
        end
        arg.on("-v","--version","Show version.") do
            puts "VC Clock #{Xlib::VERSION}";exit 0;end
        arg.on("-h","--help","Show this help message.") do
            puts arg;exit 0;end
        arg.separator("\t\t Credit : VC365 (https://github.com/VC365) \n\n")
        arg.invalid_option do |val|
            STDERR.puts "ERROR: #{val} is not a valid option."
            STDERR.puts arg
            exit(1)
        end
    end
end
# Main
module VC::Gtk
Xlib.call do
    arguments
    fcInit()
    gtk2_init(nil,nil)
end
    class_property icon_tray : VC::GtkStatusIcon= VC.gtk2_icon_new()
    VC.gtk2_icon_visible(icon_tray,1)
end
def timer(func : VC::GSourceFunc)
Xlib.call do
    time = 1000 - Time.local.millisecond
    g_source_remove(timer_id) unless timer_id.zero?
    timer_id = g_timeout_add(time <= 0 ? 1000 : time,func,nil)
end;end

def tooltip(time : String)
    return false unless Xlib.tooltip
    Xlib.gtk2_icon_tooltip_text(VC::Gtk.icon_tray,time)
end
def icon(time : Time)
Xlib.call do
    s = time.second + (soft ? time.nanosecond / 1e9 : 0)
    total = time.hour * 3600.0 + time.minute * 60.0 + s
    svg = %Q(
    <svg xmlns="http://www.w3.org/2000/svg" width="#{icon_size}" height="#{icon_size}" viewBox="0 0 16 16">
      <circle cx="8" cy="8" r="7" stroke="#ddd" stroke-width="2" fill="none"/>
      <g transform="rotate(#{(total / 43200 * 360) % 360} 8 8)">
    <line x1="8" y1="8" x2="8" y2="4.8" stroke="#ffffff" stroke-width="1.2" stroke-linecap="round"/>
      </g>
      <g transform="rotate(#{(total / 3600 * 360) % 360} 8 8)">
        <line x1="8" y1="8" x2="8" y2="3.3" stroke="#cccccc" stroke-width="0.9" stroke-linecap="round"/>
      </g>
      <g transform="rotate(#{(s * 6) % 360} 8 8)">
        <line x1="8" y1="8" x2="8" y2="2.3" stroke="#aaaaaa" stroke-width="0.6" stroke-linecap="round"/>
      </g>
      <circle cx="8" cy="8" r="0.6" fill="#fff"/>
    </svg>)

    rsvg=svg_new(svg,svg.bytesize,nil)
    unless rsvg
        puts "Error creating RsvgHandle"
        return true;end
    pix=svg_get_pixbuf(rsvg)
    if pix
        gtk2_icon_set_from_pixbuf(VC::Gtk.icon_tray,pix)
        g_object_unref(pix.as(VC::GPointer))
    end
    g_object_unref(rsvg.as(VC::GPointer))
end;end

def updateX
Xlib.call do
    time=Time.local
    tooltip(time.to_s("%H:%M:%S")) if tooltip
    icon(time) unless soft
    timer(->(data : Pointer(Void)){updateX}.as(VC::GSourceFunc))
    false
end;end

Xlib.call do
    g_timeout_add(interval,->(data : Pointer(Void)){icon(Time.local);true}.as(VC::GSourceFunc),nil) if soft
    timer(->(data : Pointer(Void)){updateX}.as(VC::GSourceFunc)) if tooltip || !soft
    gtk2_main()
end