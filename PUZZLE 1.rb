require 'mfrc522'

mfrc = MFRC522.new

mfrc.picc_request    # Detecta si hay una tarjeta
uid = mfrc.picc_select  # Obtiene la UID

puts uid.map { |byte| byte.to_s(16).rjust(2, '0') }.join(':') if uid
