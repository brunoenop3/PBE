require 'mfrc522'

mfrc = MFRC522.new

if mfrc.picc_request(1)  # Se pasa un argumento al método
  uid = mfrc.picc_select
  puts uid.map { |byte| byte.to_s(16).rjust(2, '0') }.join(':') if uid
end
