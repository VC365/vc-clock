@[Link(ldflags:"`pkg-config -libs gtk+-2.0`")]
@[Link("fontconfig")]
@[Link("rsvg-2")]
lib VC
    # Types
    alias GSourceFunc = Pointer(Void) -> Bool
    type GtkStatusIcon=Void*
    type GPointer=Void*
    type GdkPixbuf=Void*
    type RsvgHandle=Void*

    # GTK2
    fun gtk2_init=gtk_init(argc : Void*,argv : Void*)
    fun gtk2_main=gtk_main()
    fun gtk2_icon_new=gtk_status_icon_new() : GtkStatusIcon
    fun gtk2_icon_visible=gtk_status_icon_set_visible(icon : GtkStatusIcon,visible : Int8)
    fun gtk2_icon_tooltip_text=gtk_status_icon_set_tooltip_text(icon : GtkStatusIcon, text : UInt8*)
    fun gtk2_icon_set_from_pixbuf=gtk_status_icon_set_from_pixbuf(icon : GtkStatusIcon,pixbuf : GdkPixbuf)


    # GLib
    fun g_timeout_add(interval : UInt32,func : GSourceFunc,data : Void*)
    fun g_source_remove(tag : UInt32)

    # GObject
    fun g_object_unref(gpointer : GPointer)

    # RSVG
    fun svg_new=rsvg_handle_new_from_data(data : UInt8*,data_len : UInt64,error : Void*) : RsvgHandle
    fun svg_get_pixbuf=rsvg_handle_get_pixbuf(handle : RsvgHandle) : GdkPixbuf


    # FontConfig
    fun fcInit=FcInit()
end

module Xlib
  VERSION="0.1.5"
  class_property icon_size : Int32=32
  class_property tooltip : Bool=true
  class_property interval : Int32=240
  class_property soft : Bool=false
  class_property timer_id : Int64=0

  {% for m in VC.methods %}
    def self.{{m.name}}(*args)
      VC.{{m.name}}(*args)
    end
  {% end %}
  def self.call(&)
   with self yield
  end
end