#!/usr/bin/env ruby
# encoding: UTF-8

require 'gtk3'
require_relative 'puzzle1'  # Asegúrate de que puzzle1.rb esté en la misma carpeta

class MainWindow < Gtk::Window
  def initialize
    super("Ejemplo RFID con Ruby-GTK")
    set_default_size(400, 250)
    set_border_width(10)

    # Caja vertical principal
    vbox = Gtk::Box.new(:vertical, 5)
    add(vbox)

    #
    # 1. Label para mostrar info
    #
    @label_info = Gtk::Label.new("Pase su tarjeta RF para hacer login...")
    vbox.pack_start(@label_info, expand: false, fill: false, padding: 5)

    #
    # 2. TextView (texto multilínea)
    #
    @textview = Gtk::TextView.new
    @textview.wrap_mode = :word
    scrolled_window = Gtk::ScrolledWindow.new
    scrolled_window.set_policy(:automatic, :automatic)
    scrolled_window.add(@textview)
    vbox.pack_start(scrolled_window, expand: true, fill: true, padding: 5)

    #
    # 3. Botón "Display"
    #
    button_display = Gtk::Button.new(label: "Display")
    button_display.signal_connect("clicked") do
      buffer = @textview.buffer
      texto_multilinea = buffer.get_text(buffer.start_iter, buffer.end_iter, false)
      puts "Texto ingresado:\n#{texto_multilinea}"
      @label_info.text = "Mostrando: #{texto_multilinea}"
    end

    #
    # 4. Botón "Clear"
    #
    button_clear = Gtk::Button.new(label: "Clear")
    button_clear.signal_connect("clicked") do
      @label_info.text = "Pase su tarjeta RF para hacer login..."
      @textview.buffer.text = ""
    end

    # Contenedor horizontal para los botones
    hbox = Gtk::Box.new(:horizontal, 5)
    hbox.pack_start(button_display, expand: true, fill: true, padding: 5)
    hbox.pack_start(button_clear,   expand: true, fill: true, padding: 5)
    vbox.pack_start(hbox, expand: false, fill: false, padding: 5)

    show_all

    # Iniciamos el hilo que lee la tarjeta RFID
    iniciar_hilo_lector
  end

  #
  # Hilo para ejecutar el método bloqueante "esperar_tarjeta"
  #
  def iniciar_hilo_lector
    # Instanciamos nuestro lector (definido en puzzle1.rb)
    @lector = LectorRFID.new

    Thread.new do
      loop do
        # Leer la tarjeta (bloquea hasta que haya UID)
        uid_string = @lector.esperar_tarjeta

        # Para actualizar la GUI, usamos GLib::Idle.add
        GLib::Idle.add do
          @label_info.text = "Tarjeta detectada: #{uid_string}"
          # Retornamos false para que el callback se ejecute solo una vez
          false
        end
      end
    end
  end
end

# Lanzamos la aplicación
Gtk.init
window = MainWindow.new
window.signal_connect("destroy") { Gtk.main_quit }
Gtk.main
