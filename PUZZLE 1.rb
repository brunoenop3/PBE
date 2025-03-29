require 'mfrc522'

mfrc = MFRC522.new

  if mfrc.picc_request(MFRC522::PICC_REQA)
    uid = mfrc.picc_select
    cleanUid= uid[0]
    if uid
      puts "Tarjeta detectada: " + cleanUid.map { |b| "%02X" % b}.join(':')
    end
end
