#include <ArduinoJson.h>
#include <Wire.h>  
#include "LiquidCrystal_I2C.h"    // LCD I2C.

#define	LCD_colunas  16   // total de colunas do LCD.
#define	LCD_linhas  2   // total de linhas do LCD.
#define	LCD_ADDR  0x27   // endereco de acesso ao LCD no Barramento I2C.

LiquidCrystal_I2C  Display_LCD ( LCD_ADDR, LCD_colunas, LCD_linhas );

void mensagemDisplay(String cima, String baixo)
{
    Display_LCD.clear();   
    Display_LCD.setCursor( 0, 0 );
    Display_LCD.print(cima);
    Display_LCD.setCursor( 0, 1 );
    Display_LCD.print(baixo);
}

void setup() {
  Serial.begin(9600);

  Display_LCD.init(); 
	Display_LCD.backlight();
  mensagemDisplay("ChoppApp", "QRcode");
  delay(3000);
  mensagemDisplay("Por favor,","leia o QRcode");

  while (!Serial) {
    
    ; // Aguarda a conexão serial
  }

}

void loop() {
  if (Serial.available()) {
    String receivedData = Serial.readStringUntil('\n');

    // Parse do JSON
    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, receivedData);

    if (error) {
      Serial.print(F("Falha ao fazer parse: "));
      Serial.println(error.c_str());
      return;
    }

    // Acesse os dados do JSON
    String nome = doc["nome"];

    // Faça algo com os dados recebidos
    mensagemDisplay("Bem-vindo", nome);
    delay(5000);

    // Dispenser
    for(int i = 0; i <= 400; i+= 50) {
      mensagemDisplay("Abastecendo ...", (String(i) + " ml"));
      delay(1000);
    }

    // Finalização
    mensagemDisplay("Obrigado", "Volte sempre");
    delay(5000);
    mensagemDisplay("Por favor,","leia o QRcode");

  }
}
