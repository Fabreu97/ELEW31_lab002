; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
			
GPIO_PORTM_DATA_R       	EQU 	0x400633FC
GPIO_PORTM_DIR_R       		EQU 	0x40063400
GPIO_PORTL_DATA_R       EQU 0x400623FC 
			
		EXPORT	Decode_Char
		EXPORT	Read_Keyboard
		IMPORT	SysTick_Wait1ms

;---------------------------------------------------------------
;------	Read_Keyboard	----------------------------------------
; Função para ler as teclas pressionadas
; Entrada: Não tem
; Saída: R2 -> coluna pressionada
; Modifica: Nada
Read_Keyboard
	MOV		R1, #0x0000
	MOVT	R1, #0x0000
	MOV		R0, #0x0000
	MOVT	R0, #0x0000
	MOV		R2, #2_00001111
	
	MOV		R4, #2_10000000				;PM7 como saída. PM6, PM5 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x04
	BXNE	LR
	
	MOV		R4, #2_01000000				;PM6 como saída. PM7, PM5 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x03
	BXNE	LR
	
	MOV		R4, #2_00100000				;PM5 como saída. PM7, PM6 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x02
	BXNE	LR
	
	MOV		R4, #2_00010000				;PM4 como saída. PM7, PM6 e PM5 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x01
	BXNE	LR
	MOV		R2, #0x00
	
	BX		LR

;---------------------------------------------------------------
;------	Read_Keyboard_Line	------------------------------------
; Altera as portas M e verifica as linhas
; Entrada: Não tem
; Saída:
; Modifica: Nada
Read_Keyboard_Line
	MOV		R2, #2_00001111	
	LDR		R0, =GPIO_PORTM_DIR_R
	LDR		R1, [R0]
	AND		R1, R2
	ORR		R1, R4
	STR		R1, [R0]
	LDR		R0, =GPIO_PORTM_DATA_R
	LDR		R3, [R0]
	AND		R3, #2_00001111
	STR		R3, [R0]
	
	MOV		R0, #5
	PUSH	{LR}
	BL		SysTick_Wait1ms
	POP		{LR}
	
	PUSH	{LR}
	BL		PortL_Input
	POP		{LR}
	
	CMP		R0, #0x0f
	PUSH	{LR}
	BLNE	Read_Line
	POP		{LR}
	CMP		R0, #0x0f
	PUSH	{LR}
	BLEQ	Not_Line
	POP		{LR}	
	BX		LR

Not_Line
	MOV		R1, #0x0000
	MOVT	R1, #0x0000
	MOV		R0, #0x0000
	MOVT	R0, #0x0000
	BX		LR

;---------------------------------------------------------------
;------	Read_Line	--------------------------------------------
; Função para ler as linhas pressionadas
; Entrada: Não tem
; Saída: R1 -> Linha pressionada
; Modifica: Nada
Read_Line
	MOV		R1, R0
	AND		R1, #2_00000001
	CMP		R1, #0x00
	BNE	Line_2
	MOV		R1, #0x01
	BXEQ	LR

Line_2
	MOV		R1, R0
	AND		R1, #2_00000010
	CMP		R1, #0x00
	BNE	Line_3
	MOV		R1, #0x02
	BXEQ	LR

Line_3
	MOV		R1, R0
	AND		R1, #2_00000100
	CMP		R1, #0x00
	BNE		Line_4
	MOV		R1, #0x03
	BXEQ	LR

Line_4
	MOV		R1, R0
	AND		R1, #2_00001000
	CMP		R1, #0x00
	MOV		R1, #0x04
	BXEQ	LR
	MOV		R1, #0x00
	MOV		R2, #0x00
	BX		LR

; -------------------------------------------------------------------------------
; Função PortL_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortL_Input
	MOV		R0, #0x0000
	MOVT	R0, #0x0000
	LDR		R1, =GPIO_PORTL_DATA_R			;Carrega o valor do offset do data register
	LDR		R0, [R1]						;Lê no barramento de dados dos pinos
	AND		R0, #2_00001111
	BX 		LR								;Retorno

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
	BX		LR
	
Decode_Char_Coluna_1_Linha_2					;4
	CMP		R1, #2
	BNE		Decode_Char_Coluna_1_Linha_3
	LSL		R6, #8
	ORR		R6, #0x34
	BX		LR
	
Decode_Char_Coluna_1_Linha_3					;7
	CMP		R1, #3
	BNE		Decode_Char_Coluna_1_Linha_4
	LSL		R6, #8
	ORR		R6, #0x37
	BX		LR
	
Decode_Char_Coluna_1_Linha_4					;*
	CMP		R1, #4
	BXNE	LR									;Se coluna == 1 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x2a
	BX		LR
	
; Coluna 2 =====================================
Decode_Char_Coluna_2
	CMP		R2, #2
	BNE		Decode_Char_Coluna_3
	
Decode_Char_Coluna_2_Linha_1					;2
	CMP		R1, #1
	BNE		Decode_Char_Coluna_2_Linha_2
	LSL		R6, #8
	ORR		R6, #0x32
	BX		LR
	
Decode_Char_Coluna_2_Linha_2					;5
	CMP		R1, #2
	BNE		Decode_Char_Coluna_2_Linha_3
	LSL		R6, #8
	ORR		R6, #0x35
	BX		LR
	
Decode_Char_Coluna_2_Linha_3					;8
	CMP		R1, #3
	BNE		Decode_Char_Coluna_2_Linha_4
	LSL		R6, #8
	ORR		R6, #0x38
	BX		LR
	
Decode_Char_Coluna_2_Linha_4					;0
	CMP		R1, #4
	BXNE	LR									;Se coluna == 2 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x30
	BX		LR
	
; Coluna 3 =====================================
Decode_Char_Coluna_3
	CMP		R2, #3
	BNE		Decode_Char_Coluna_4
	
Decode_Char_Coluna_3_Linha_1					;3
	CMP		R1, #1
	BNE		Decode_Char_Coluna_3_Linha_2
	LSL		R6, #8
	ORR		R6, #0x33
	BX		LR
	
Decode_Char_Coluna_3_Linha_2					;6
	CMP		R1, #2
	BNE		Decode_Char_Coluna_3_Linha_3
	LSL		R6, #8
	ORR		R6, #0x36
	BX		LR
	
Decode_Char_Coluna_3_Linha_3					;9
	CMP		R1, #3
	BNE		Decode_Char_Coluna_3_Linha_4
	LSL		R6, #8
	ORR		R6, #0x39
	BX		LR
	
Decode_Char_Coluna_3_Linha_4					;#
	CMP		R1, #4
	BXNE	LR									;Se coluna == 3 e linha invalida, retorna
	MOV		R5, #1								;booleano R5 (fim da senha) = 1
	BX		LR

; Coluna 4 =====================================
Decode_Char_Coluna_4
	CMP		R2, #4
	BXNE	LR
	
Decode_Char_Coluna_4_Linha_1					;A
	CMP		R1, #1
	BNE		Decode_Char_Coluna_4_Linha_2
	LSL		R6, #8
	ORR		R6, #0x41
	BX		LR
	
Decode_Char_Coluna_4_Linha_2					;B
	CMP		R1, #2
	BNE		Decode_Char_Coluna_4_Linha_3
	LSL		R6, #8
	ORR		R6, #0x42
	BX		LR
	
Decode_Char_Coluna_4_Linha_3					;C
	CMP		R1, #3
	BNE		Decode_Char_Coluna_4_Linha_4
	LSL		R6, #8
	ORR		R6, #0x43
	BX		LR
	
Decode_Char_Coluna_4_Linha_4					;D
	CMP		R1, #4
	BXNE	LR									;Se coluna == 4 e linha invalida, retorna
	LSL		R6, #8
	ORR		R6, #0x44

	BX		LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo