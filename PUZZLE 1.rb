require 'mfrc522'

mfrc = MFRC522.new

loop do
  if mfrc.picc_request(MFRC522::PICC_REQIDL)
    uid = mfrc.picc_select
    if uid
      puts "Tarjeta detectada: " + uid.map { |byte| byte.to_s(16).rjust(2, '0') }.join(':')
    end
  end
  sleep 1  # Espera un poco antes de volver a checar
end
