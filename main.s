; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
; constante de strings		
MSG_COFRE_ABERTO		DCB			"  Cofre aberto  ",0 ; essa string tem 16 caracteres
MSG_NOVA_SENHA			DCB			"  Nova senha:   ",0


		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  GPIO_Init
		IMPORT	LCD_Init
		IMPORT	LCD_Write_Character
		IMPORT	LCD_Write_String
		IMPORT	LCD_Move_Cursor
		IMPORT	LCD_Reset
		IMPORT	Read_Keyboard

; -------------------------------------------------------------------------------
Start  		
	BL 		PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL 		SysTick_Init
	BL 		GPIO_Init                 	;Chama a subrotina que inicializa os GPIO
	BL		LCD_Init					;Chama a subrotina que inicializa o LCD
	LDR		R0, =MSG_COFRE_ABERTO		;Ponteiro para a mensagem "  Cofre aberto  " // linha 26 encontra a constante string
	BL		LCD_Write_String			;Função de escrever uma string no LCD, presta atenção no cursor q deixei ele piscando)
	MOV		R0, #0xC0					;Posição do inicio da segunda linha do cursor 
	BL		LCD_Move_Cursor				;Move o Cursor na posição R0
	LDR		R0, =MSG_NOVA_SENHA			;Ponteiro para a mensagem "  Nova senha:   "
	BL		LCD_Write_String			;Função de escrever uma string no LCD, presta atenção no cursor(deixei ele piscando)
	MOV		R0, #0x80					;Posição do inicio da primeira linha do cursor
	BL		LCD_Move_Cursor
	MOV		R0, #'*'
	BL		LCD_Write_Character			;Escreve um caracter na posição R0 do LCD
	BL		Read_Keyboard
	;BL		LCD_Reset;					;Limpa a tela do LCD e move o cursor para a primeira linha no inicio
	
; -------------------------------------------------------------------------------
; Função main()
Main
	
;--------------------------------------------------------------------------------
Fim
	NOP;
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo