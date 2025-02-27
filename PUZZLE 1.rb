require 'mfrc522'

reader = MFRC522.new

puts 'Acerca una tarjeta al lector...'

# Espera hasta que una tarjeta esté presente
reader.picc_request(MFRC522::PICC_REQA)

# Lee la UID de la tarjeta
uid = reader.picc_select

if uid
  puts "UID de la tarjeta: #{uid.map { |byte| byte.to_s(16).upcase }.join(':')}"
else
  puts 'No se pudo leer la UID de la tarjeta.'
end
