; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
			
		EXPORT	Decode_Char

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