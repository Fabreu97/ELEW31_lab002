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
	;BL		LCD_Reset;					;Limpa a tela do LCD e move o cursor para a primeira linha no inicio
	
; -------------------------------------------------------------------------------
; Função main()
Main
	BL		Read_Keyboard
	BL		Decode_Char
	BL		LCD_Write_Character			;Escreve um caracter na posição R0 do LCD
	B 		Main


;---------------------------------------------------------------
;------	Decode_Char	--------------------------------------------
; Função para ler as linhas pressionadas
; Entrada: Não tem
; Saída: R1 -> Linha pressionada, R2 -> Coluna pressionada
; Modifica: Nada
Decode_Char
	MOVT	R0, #0xffff
	MOV		R0, #0xff00
	CMP		R5, #1
	ITTTE	EQ
	MOVTEQ	R6, #0x0000
	MOVEQ	R6, #0x0000
	MOVEQ	R5, #0
	ANDNE	R6, R0

; Coluna 1 =====================================
Decode_Char_Coluna_1
	CMP		R2, #1
	BNE		Decode_Char_Coluna_2

Decode_Char_Coluna_1_Linha_1					;1
	CMP		R1, #1
	BNE		Decode_Char_Coluna_1_Linha_2
	LSL		R6, #8
	ORR		R6, #0x31
	
Decode_Char_Coluna_1_Linha_2					;4
	CMP		R1, #2
	BNE		Decode_Char_Coluna_1_Linha_3
	LSL		R6, #8
	ORR		R6, #0x34
	
Decode_Char_Coluna_1_Linha_3					;7
	CMP		R1, #3
	BNE		Decode_Char_Coluna_1_Linha_4
	LSL		R6, #8
	ORR		R6, #0x37
	
Decode_Char_Coluna_1_Linha_4					;*
	CMP		R1, #4
	BXNE	LR									;Se coluna == 1 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x2a
	
; Coluna 2 =====================================
Decode_Char_Coluna_2
	CMP		R2, #2
	BNE		Decode_Char_Coluna_3
	
Decode_Char_Coluna_2_Linha_1					;2
	CMP		R1, #1
	BNE		Decode_Char_Coluna_2_Linha_2
	LSL		R6, #8
	ORR		R6, #0x32
	
Decode_Char_Coluna_2_Linha_2					;5
	CMP		R1, #2
	BNE		Decode_Char_Coluna_2_Linha_3
	LSL		R6, #8
	ORR		R6, #0x35
	
Decode_Char_Coluna_2_Linha_3					;8
	CMP		R1, #3
	BNE		Decode_Char_Coluna_2_Linha_4
	LSL		R6, #8
	ORR		R6, #0x38
	
Decode_Char_Coluna_2_Linha_4					;0
	CMP		R1, #4
	BXNE	LR									;Se coluna == 2 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x30
	
; Coluna 3 =====================================
Decode_Char_Coluna_3
	CMP		R2, #3
	BNE		Decode_Char_Coluna_4
	
Decode_Char_Coluna_3_Linha_1					;3
	CMP		R1, #1
	BNE		Decode_Char_Coluna_3_Linha_2
	LSL		R6, #8
	ORR		R6, #0x33
	
Decode_Char_Coluna_3_Linha_2					;6
	CMP		R1, #2
	BNE		Decode_Char_Coluna_3_Linha_3
	LSL		R6, #8
	ORR		R6, #0x36
	
Decode_Char_Coluna_3_Linha_3					;9
	CMP		R1, #3
	BNE		Decode_Char_Coluna_3_Linha_4
	LSL		R6, #8
	ORR		R6, #0x39
	
Decode_Char_Coluna_3_Linha_4					;#
	CMP		R1, #4
	BXNE	LR									;Se coluna == 3 e linha invalida, retorna
	MOV		R5, #1								;booleano R5 (fim da senha) = 1

; Coluna 4 =====================================
Decode_Char_Coluna_4
	CMP		R2, #4
	BXNE	LR
	
Decode_Char_Coluna_4_Linha_1					;A
	CMP		R1, #1
	BNE		Decode_Char_Coluna_4_Linha_2
	LSL		R6, #8
	ORR		R6, #0x41
	
Decode_Char_Coluna_4_Linha_2					;B
	CMP		R1, #2
	BNE		Decode_Char_Coluna_4_Linha_3
	LSL		R6, #8
	ORR		R6, #0x42
	
Decode_Char_Coluna_4_Linha_3					;C
	CMP		R1, #3
	BNE		Decode_Char_Coluna_4_Linha_4
	LSL		R6, #8
	ORR		R6, #0x43
	
Decode_Char_Coluna_4_Linha_4					;D
	CMP		R1, #4
	BXNE	LR									;Se coluna == 4 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x44

	BX		LR
;--------------------------------------------------------------------------------
Fim
	NOP;
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo