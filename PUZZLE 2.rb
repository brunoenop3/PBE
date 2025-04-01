#!/usr/bin/env ruby
# encoding: UTF-8

require 'gtk3'
require_relative 'PUZZLE 1'  # Ajusta el nombre/ubicación según corresponda
require 'thread'

class MainWindow < Gtk::ApplicationWindow
  def initialize(application)
    # Llamamos al constructor de Gtk::ApplicationWindow, pasándole la app
    super(application)

    # Ajustes de la ventana
    self.title = "Ejemplo RFID con Ruby-GTK (Application)"
    self.default_width = 400
    self.default_height = 250
    self.border_width = 10

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

    # Mostramos todos los widgets
    show_all

    # Iniciamos el hilo que lee la tarjeta RFID
    iniciar_hilo_lector
  end

  #
  # Hilo para ejecutar el método bloqueante "esperar_tarjeta"
  #
  def iniciar_hilo_lector
    @lector = LectorRFID.new  # Clase definida en 'PUZZLE 1'

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

# ------------------------------------------------------------------------------
# APLICACIÓN
# ------------------------------------------------------------------------------
# En lugar de Gtk.init / Gtk.main, creamos una Gtk::Application.

app = Gtk::Application.new("org.ruby.rfid", :flags_none)

# Cuando la aplicación se "active", creamos y mostramos la ventana
app.signal_connect("activate") do |application|
  window = MainWindow.new(application)
  window.present
end

# Ejecutamos la aplicación
app.run([$0] + ARGV)
