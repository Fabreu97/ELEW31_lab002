; lcd.s
; Arquivo para ter subrotinas para controlar um LCD.
; Desenvolvido para a placa EK-TM4C1294XL.
; Autor: Fernando Abreu e Eduardo Veiga
; 11/06/2024

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Definições dos ports
; PORT K
GPIO_PORTK_DATA_R       	EQU 	0x400613FC
GPIO_PORTK_DIR_R        	EQU 	0x40061400
GPIO_PORTK_IS_R         	EQU		0x40061404
GPIO_PORTK_IBE_R        	EQU 	0x40061408
GPIO_PORTK_IEV_R        	EQU 	0x4006140C
GPIO_PORTK_IM_R         	EQU 	0x40061410
GPIO_PORTK_RIS_R        	EQU 	0x40061414
GPIO_PORTK_MIS_R        	EQU 	0x40061418
GPIO_PORTK_ICR_R        	EQU 	0x4006141C
GPIO_PORTK_AFSEL_R      	EQU 	0x40061420
GPIO_PORTK_PUR_R        	EQU 	0x40061510
GPIO_PORTK_DEN_R        	EQU 	0x4006151C
GPIO_PORTK_LOCK_R       	EQU 	0x40061520
GPIO_PORTK_CR_R         	EQU 	0x40061524
GPIO_PORTK_AMSEL_R      	EQU 	0x40061528
GPIO_PORTK_PCTL_R       	EQU 	0x4006152C
GPIO_PORTK              	EQU		2_000001000000000
; PORT M
GPIO_PORTM_DATA_R       	EQU 	0x400633FC
GPIO_PORTM_DIR_R       		EQU 	0x40063400
GPIO_PORTM_IS_R         	EQU 	0x40063404
GPIO_PORTM_IBE_R	        EQU 	0x40063408
GPIO_PORTM_IEV_R    	    EQU 	0x4006340C
GPIO_PORTM_IM_R         	EQU 	0x40063410
GPIO_PORTM_RIS_R        	EQU 	0x40063414
GPIO_PORTM_MIS_R       		EQU 	0x40063418
GPIO_PORTM_ICR_R        	EQU 	0x4006341C
GPIO_PORTM_AFSEL_R      	EQU 	0x40063420
GPIO_PORTM_PUR_R        	EQU 	0x40063510
GPIO_PORTM_DEN_R        	EQU 	0x4006351C
GPIO_PORTM_LOCK_R       	EQU 	0x40063520
GPIO_PORTM_CR_R         	EQU 	0x40063524
GPIO_PORTM_AMSEL_R      	EQU 	0x40063528
GPIO_PORTM_PCTL_R       	EQU 	0x4006352C
GPIO_PORTM               	EQU 	2_000100000000000
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
;
;		EXPORT E IMPORT as FUNÇÕES AQUI
		EXPORT	LCD_Init
		EXPORT	LCD_Write_Character
		EXPORT	LCD_Write_String
		EXPORT	LCD_Move_Cursor
		EXPORT	LCD_Reset
		EXPORT	LCD_Command
; -------------------------------------------------------------------------------
		IMPORT	SysTick_Wait1ms
		IMPORT	SysTick_Wait1us
;---------------------------------------------------------------
;------------LCD_Init------------
; Função de inicialização do LCD
; Entrada: Não tem
; Saída: Não tem
; Modifica: R0, R1, R2, R3
LCD_Init
			PUSH	{R0,R1,R2,R3}
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			LDRB	R1, [R3];					
			AND		R1, R1, #2_11111100;			Zero os bits M0			TO REDO
			ORR		R1, R1, #2_00000100;			Set o bit M2~M1
			STRB	R1, [R3];
			
			; 1. Escrevendo o Comando 0x38 -> Configura o LCD em modo de 8 bits e 2 linhas
			MOV 	R1, #0x38;					
			STRB	R1, [R2];
			; 2. Configurar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			; 1. Escrevendo o Comando 0x06 -> autoincremento para direita
			MOV 	R1, #0x06;					
			STRB	R1, [R2];
			; 2. Configurar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			; 1. Escrevendo o Comando 0x0E -> habilitar o display + cursor + não-pisca
			MOV 	R1, #0x0F;					
			STRB	R1, [R2];
			; 2. Configurar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			; 1. Escrevendo o Comando 0x01 -> Reset
			MOV		R1, #0x01;
			STRB	R1, [R2];
			; 2. Configurar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #1640;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			; 1. Escrevendo o Comando 0x02 -> Home
			MOV		R1, #0x02;
			STRB	R1, [R2];
			; 2. Configurar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #1640;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			POP		{R0,R1,R2,R3}
			BX		LR;							Retorno
;------------LCD_Inst_Escr_Habi------------
; Função de habilitar os Pinos de Controles EN, R/W, RS == (100)
; Entrada: R3(GPIO_PORTM_DATA_R)
; Saída: Não tem
; Modifica: R0, R1
LCD_Inst_Escr_Habi
			LDRB	R1, [R3];					
			AND		R1, R1, #2_11111100;			Zero os bits M1~M0			TO REDO
			ORR		R1, R1, #2_00000100;			Set o bit M2
			STRB	R1, [R3];
			MOV		R0,	#10;						Espera 10us
			PUSH	{LR}
			BL		SysTick_Wait1us
			POP		{LR}
			
			BX		LR;		
;---------------------------------------------------------------
;------------LCD_DESABLE_TIME_COMAND------------
; Função de desabilitar o EN do LCD e espera o tempo do comando
; Entrada: R0(Tempo de espera em us), R3(GPIO_PORTM_DATA_R)
; Saída: Não tem
; Modifica: R0, R1
LCD_DESABLE_TIME_COMAND
			LDRB	R1, [R3];					
			AND		R1, R1, #2_11111011;			Zerando os bit M2(ENABLE)			TO REDO
			STRB	R1, [R3]
			PUSH	{LR}
			BL		SysTick_Wait1us
			POP		{LR}
			
			BX		LR

;---------------------------------------------------------------
;-------------LCD_Write_String-------------------------------
; Função para escrever uma string no LCD
; Entrada: R0(Endereço da string)
; Saída: Não tem
; Modifica: Nada
LCD_Write_String
			PUSH	{R0, R1, R2}
			MOV		R2, R0
			MOV		R1, #0;						variavel para percorrer string
Percorrer_String
			LDRB	R0, [R1,R2];
			PUSH	{LR}
			BL		LCD_Write_Character;		escrever o character
			POP		{LR}
			ADD		R1,R1,#1;					R1++				
			CMP		R0, #0
			BNE		Percorrer_String
			POP		{R0, R1, R2}
			BX		LR
;---------------------------------------------------------------
;-------------LCD_Write_Character-------------------------------
; Função para escrever uma string no LCD
; Entrada: R0(o caracter)
; Saída: Não tem
; Modifica: Nada
LCD_Write_Character
			PUSH	{R0,R1,R2,R3}
			CMP		R0, #0
			BEQ		end_write_character
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			; 1. Escrevendo o Dado(character)
			STRB	R0, [R2];
			; 2. Configurar os Pinos EN R/W RS para 101
			PUSH	{LR}
			BL		LCD_Setup_Write
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
end_write_character
			POP		{R0,R1,R2,R3}
			BX		LR
;---------------------------------------------------------------
;------------LCD_Setup_Write------------
; Função para configurar a escrita EN R/W RS == (101)
; Entrada: R3(GPIO_PORTM_DATA_R)
; Saída: Não tem
; Modifica: R0, R1
LCD_Setup_Write
			LDRB	R1, [R3];					
			AND		R1, R1, #2_11111101;			Zero os bit M1			TO REDO
			ORR		R1, R1, #2_00000101;			Set o bit M2 e M0
			STRB	R1, [R3];
			MOV		R0,	#10;						Espera 10us
			PUSH	{LR}
			BL		SysTick_Wait1us
			POP		{LR}
			BX		LR

;---------------------------------------------------------------
;------------------LCD_Move_Cursor------------------------------
; Função para levar o curso do LCD para o Inicio
; Entrada: R0(Posição do Cursor irá ficar)
; Saída: Não tem
; Modifica: Nada
LCD_Move_Cursor
			PUSH	{R0,R1,R2,R3}
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			; 1. Escrever o comando para levar o Cursor para o inicio
			MOV		R1, R0;
			STRB	R1, [R2];
			; 2. Configurar	os pinos EN R/W RS	== (100)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			
			POP		{R0,R1,R2,R3}
			BX		LR
			
;---------------------------------------------------------------
;------------------LCD_Reset------------------------------
; Função para resetar o LCD
; Entrada: Não tem
; Saída: Não tem
; Modifica: Nada
LCD_Reset
			PUSH	{R0,R1,R2,R3}
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			; 1. Escrevendo o Comando 0x01 -> Resetar
			MOV 	R1, #0x01;					
			STRB	R1, [R2];
			; 2. Habilitar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #1640;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			POP		{R0,R1,R2,R3};
			BX		LR
;---------------------------------------------------------------
;------------------LCD_Command------------------------------
; Função para executar um comando que necessite 40us para o LCD executar
; Entrada: R0
; Saída: Não tem
; Modifica: Nada
LCD_Command
			PUSH	{R0,R1,R2,R3}
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			; 1. Escrevendo o Comando 0x01 -> Resetar
			MOV 	R1, R0;					
			STRB	R1, [R2];
			; 2. Habilitar os pinos EN R/W RS (M2~M0)
			PUSH	{LR}
			BL		LCD_Inst_Escr_Habi
			POP		{LR}
			; 3. Desabilitar EN pelo tempo necessário do comando
			PUSH	{LR}
			MOV		R0, #40;
			BL		LCD_DESABLE_TIME_COMAND
			POP		{LR}
			POP		{R0,R1,R2,R3};
			BX		LR

	ALIGN
	END
