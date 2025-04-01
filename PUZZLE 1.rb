require 'mfrc522'

class LectorRFID
  def initialize
    @mfrc = MFRC522.new
  end
  def esperar_tarjeta
    loop do
      if @mfrc.picc_request(MFRC522::PICC_REQA)
        uid = @mfrc.picc_select
        if uid
          clean_uid = uid[0]
          uid_string = clean_uid.map { |b| "%02X" % b }.join(':')
          puts "Tarjeta detectada: #{uid_string}"
          return uid_string
        end
      end
      sleep 0.1  # Evita saturar la CPU
    end
  end
end
