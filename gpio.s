; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Autor: Fernando Pereira Gomes de Abreu
; 05/05/2024

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; Definições dos Ports
;
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    	0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    	0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU   	0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU   	0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    	0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    	0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    	0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    	0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    	0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    	0x40060000
GPIO_PORTJ_AHB_IS_R     	EQU	   	0x40060404			;	MACROS DE ENDEREÇOS DE INTERRUPÇÕES	
GPIO_PORTJ_AHB_IBE_R    	EQU    	0x40060408
GPIO_PORTJ_AHB_IEV_R    	EQU    	0x4006040C
GPIO_PORTJ_AHB_IM_R     	EQU    	0x40060410
GPIO_PORTJ_AHB_RIS_R    	EQU    	0x40060414
GPIO_PORTJ_AHB_MIS_R    	EQU    	0x40060418
GPIO_PORTJ_AHB_ICR_R    	EQU	   	0x4006041C
GPIO_PORTJ               	EQU    	2_000000100000000
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
; PORT N
GPIO_PORTN_LOCK_R    		EQU    	0x40064520
GPIO_PORTN_CR_R      		EQU    	0x40064524
GPIO_PORTN_AMSEL_R   		EQU    	0x40064528
GPIO_PORTN_PCTL_R    		EQU    	0x4006452C
GPIO_PORTN_DIR_R     		EQU    	0x40064400
GPIO_PORTN_AFSEL_R   		EQU    	0x40064420
GPIO_PORTN_DEN_R     		EQU    	0x4006451C
GPIO_PORTN_PUR_R     		EQU    	0x40064510	
GPIO_PORTN_DATA_R    		EQU    	0x400643FC
GPIO_PORTN               	EQU    	2_001000000000000
;	Port L
GPIO_PORTL_DATA_BITS_R  EQU 0x40062000
GPIO_PORTL_DATA_R       EQU 0x400623FC 
GPIO_PORTL_DIR_R        EQU 0x40062400 
GPIO_PORTL_IS_R         EQU 0x40062404 
GPIO_PORTL_IBE_R        EQU 0x40062408 
GPIO_PORTL_IEV_R        EQU 0x4006240C 
GPIO_PORTL_IM_R         EQU 0x40062410 
GPIO_PORTL_RIS_R        EQU 0x40062414 
GPIO_PORTL_MIS_R        EQU 0x40062418 
GPIO_PORTL_ICR_R        EQU 0x4006241C 
GPIO_PORTL_AFSEL_R      EQU 0x40062420 
GPIO_PORTL_DR2R_R       EQU 0x40062500 
GPIO_PORTL_DR4R_R       EQU 0x40062504 
GPIO_PORTL_DR8R_R       EQU 0x40062508 
GPIO_PORTL_ODR_R        EQU 0x4006250C 
GPIO_PORTL_PUR_R        EQU 0x40062510 
GPIO_PORTL_PDR_R        EQU 0x40062514 
GPIO_PORTL_SLR_R        EQU 0x40062518 
GPIO_PORTL_DEN_R        EQU 0x4006251C 
GPIO_PORTL_LOCK_R       EQU 0x40062520 
GPIO_PORTL_CR_R         EQU 0x40062524 
GPIO_PORTL_AMSEL_R      EQU 0x40062528 
GPIO_PORTL_PCTL_R       EQU 0x4006252C 
GPIO_PORTL_ADCCTL_R     EQU 0x40062530 
GPIO_PORTL_DMACTL_R     EQU 0x40062534 
GPIO_PORTL_SI_R         EQU 0x40062538 
GPIO_PORTL_DR12R_R      EQU 0x4006253C 
GPIO_PORTL_WAKEPEN_R    EQU 0x40062540 
GPIO_PORTL_WAKELVL_R    EQU 0x40062544 
GPIO_PORTL_WAKESTAT_R   EQU 0x40062548 
GPIO_PORTL_PP_R         EQU 0x40062FC0 
GPIO_PORTL_PC_R         EQU 0x40062FC4
GPIO_PORTL				EQU	2_000010000000000
;QPNMLKJHGFEDCBA
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
;
;		EXPORT E IMPORT as FUNÇÕES AQUI
		EXPORT  GPIO_Init
		EXPORT	LCD_Init
		EXPORT	LCD_Write_Character
		EXPORT	LCD_Write_String
		EXPORT	LCD_Move_Cursor
		EXPORT	LCD_Reset
		EXPORT	Read_Keyboard
; -------------------------------------------------------------------------------
		IMPORT	SysTick_Wait1ms
		IMPORT	SysTick_Wait1us

; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
GPIO_Init
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTK                 ;Seta o bit da porta K
			ORR		R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR     R1, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR     R1, #GPIO_PORTN					;Seta o bit da porta N, fazendo com OR
			ORR     R1, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTK                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR     R2, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR     R2, #GPIO_PORTN					;Seta o bit da porta N, fazendo com OR
			ORR     R2, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
; 2. Limpar o AMSEL para desabilitar a função analógica
			MOV		R1, #0x00;
			LDR		R0, =GPIO_PORTJ_AHB_AMSEL_R;
			STR		R1, [R0];
			LDR		R0, =GPIO_PORTK_AMSEL_R;
			STR		R1, [R0];
			LDR		R0, =GPIO_PORTM_AMSEL_R;
			STR		R1, [R0];
			LDR		R0, =GPIO_PORTN_AMSEL_R;
			STR		R1, [R0];
			LDR		R0, =GPIO_PORTL_AMSEL_R;
			STR		R1, [R0];
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
			
			LDR     R0, =GPIO_PORTK_PCTL_R			;Carrega o R0 com o endereço do PCTL para a porta K
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta K da memória
			
			LDR     R0, =GPIO_PORTM_PCTL_R			;Carrega o R0 com o endereço do PCTL para a porta M
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta M da memória
			
            LDR     R0, =GPIO_PORTN_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
			
            LDR     R0, =GPIO_PORTL_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
; 4. DIR para 0 se for entrada, 1 se for saída
			LDR		R0, =GPIO_PORTJ_AHB_DIR_R
			MOV		R1, #2_00000011					;J1~J0
			STRB	R1, [R0]
			
			LDR		R0, =GPIO_PORTK_DIR_R
			MOV		R1, #2_11111111;				;K7~K0 USADO NO LCD
			STRB	R1, [R0]
			
			LDR		R0, =GPIO_PORTM_DIR_R
			MOV		R1, #2_11110111					;M7~M4 USADO NO TECLADO ; M2~M0 USADO NO LCD 
			STRB	R1, [R0]
			
            LDR     R0, =GPIO_PORTN_DIR_R			;Carrega o R0 com o endereço do DIR para a porta N
			MOV     R1, #2_00000011					;PN0, PN1
            STRB    R1, [R0]						;Guarda no registrador
		
            LDR     R0, =GPIO_PORTL_DIR_R			;Carrega o R0 com o endereço do DIR para a porta L
			MOV     R1, #2_00000000					;PL0 ~ PL3 usados pelo teclado
            STRB    R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PJ para não transformar entradas em saídas desnecessárias
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa					;Escreve na porta
			MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_PORTK_AFSEL_R			;Carrega o endereço do AFSEL da porta K
            STR     R1, [R0]						;Escreve na porta
			
			LDR     R0, =GPIO_PORTM_AFSEL_R			;Carrega o endereço do AFSEL da porta M
            STR     R1, [R0]						;Escreve na porta
			
            LDR     R0, =GPIO_PORTN_AFSEL_R			;Carrega o endereço do AFSEL da porta N
            STR     R1, [R0]						;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R		;Carrega o endereço do DEN
			MOV     R1, #2_00000011                 ;J1 J0     
            STRB    R1, [R0]
			
			LDR		R0, =GPIO_PORTK_DEN_R			;Carrega o endereço do DEN
			MOV		R1,	#2_11111111					;K7~K0
			STRB	R1,[R0]
			
			LDR		R0, =GPIO_PORTM_DEN_R			;Carrega o endereço do DEN
			MOV		R1,	#2_11110111					;M7~M4 ; M2~M0
			STRB	R1,[R0]
			
			LDR     R0, =GPIO_PORTN_DEN_R			;Carrega o endereço do DEN
            MOV     R1, #2_00000011                 ;N1 N0
            STRB    R1, [R0]						;Escreve no registrador da memória funcionalidade digital
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_11							;Habilitar funcionalidade digital de resistor de pull-up 
            STRB    R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
			
			LDR     R0, =GPIO_PORTL_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00001111							;Habilitar funcionalidade digital de resistor de pull-up 
            STRB    R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
; 8. Desabilitar as configurações dos registradores GPIOIM
			LDR		R0, =GPIO_PORTJ_AHB_IM_R
			MOV		R1, #2_00;
			STRB	R1, [R0];
; 9. Configurar o tipo de interrupção no registrador GPIOIS
;	0 -> borda
;	1 -> nivel
			LDR		R0, =GPIO_PORTJ_AHB_IS_R;
			MOV		R1, #2_00;
			STRB	R1, [R0];
; 10. Configurar se uma ou ambas as bordas no registrador GPIOIBE
;	0 -> uma borda
;	1 -> ambas as bordas
			LDR		R0, =GPIO_PORTJ_AHB_IBE_R;
			MOV		R1, #2_00;
			STRB	R1, [R0];
; 11. Configurar o tipo de borda ou nivel se é subida/alta ou descida/baixo no registrador GPIOIEV
;	0	->	borda de descida ou nível lógico baixo
;	1	->	borda de subida ou nível lógico alto
			LDR		R0, =GPIO_PORTJ_AHB_IEV_R;
			MOV		R1, #2_00;
			STRB	R1, [R0];
; 12. Habilitar as configurações dos registradores GPIOIM
			LDR		R0, =GPIO_PORTJ_AHB_IM_R
			MOV		R1, #2_11;
			STRB	R1, [R0];
			
; 13. Setar a prioriedade no NVIC(pág 116)  PRIx // Para a Port J o número de interrupção é 51 / deve ser x =12 
			
; 14. Habilitar a interrupção no NVIC(pág)  ENx  // x varia de 0 a 3
			BX      LR;						retorno GPIO_Init

; -------------------------------------------------------------------------------
; -------------------------------Funções-----------------------------------------
; -------------------------------------------------------------------------------
;------------LCD_Init------------
; Função de inicialização do LCD
; Entrada: Não tem
; Saída: Não tem
; Modifica: R0, R1, R2, R3

LCD_Init
			LDR		R2, =GPIO_PORTK_DATA_R
			LDR		R3,	=GPIO_PORTM_DATA_R
			LDRB	R1, [R3];					
			AND		R1, R1, #2_11111100;			Zero os bits M0			TO REDO
			ORR		R1, R1, #2_00000100;			Set o bit M2~M1
			STRB	R1, [R3];
			
			; 1. Escrevendo o Comando 0x38 -> Configura o LCD em modo de 8 bits e 2 linhas
			MOV 	R1, #0x38;					
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
			
			; 1. Escrevendo o Comando 0x06 -> autoincremento para direita
			MOV 	R1, #0x06;					
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
			
			; 1. Escrevendo o Comando 0x0E -> habilitar o display + cursor + não-pisca
			MOV 	R1, #0x0F;					
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
			
			; 1. Escrevendo o Comando 0x01 -> Reset
			MOV		R1, #0x01;
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
			
			; 1. Escrevendo o Comando 0x02 -> Home
			MOV		R1, #0x02;
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
			
			BX		LR;							Retorno
;---------------------------------------------------------------
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
; Modifica: R1
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
; Entrada: R0
; Saída: Não tem
; Modifica: R0
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
;------	Read_Keyboard	----------------------------------------
; Função para ler as teclas pressionadas
; Entrada: Não tem
; Saída:
; Modifica: Nada
Read_Keyboard
	MOV		R2, #2_10001111				;PM7 como saída. PM6, PM5 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x04
	BXNE	LR
	
	MOV		R2, #2_01001111				;PM6 como saída. PM7, PM5 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x03
	BXNE	LR
	
	MOV		R2, #2_00101111				;PM5 como saída. PM7, PM6 e PM4 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x02
	BXNE	LR
	
	MOV		R2, #2_00011111				;PM4 como saída. PM7, PM6 e PM5 como entrada
	PUSH	{LR}
	BL		Read_Keyboard_Line
	POP		{LR}
	CMP		R1, #0x00
	MOV		R2, #0x04
	BXNE	LR
	
	BX		LR

;---------------------------------------------------------------
;------	Read_Keyboard_Line	------------------------------------
; Altera as portas M e verifica as linhas
; Entrada: Não tem
; Saída:
; Modifica: Nada
Read_Keyboard_Line
	LDR		R0, =GPIO_PORTM_DIR_R
	LDR		R1, [R0]
	AND		R1, R2
	STR		R1, [R0]
	
	PUSH	{LR}
	BL		PortL_Input
	POP		{LR}
	
	CMP		R0, #0x00
	PUSH	{LR}
	BLNE	Read_Line
	POP		{LR}
	
	BX		LR

;---------------------------------------------------------------
;------	Read_Line	--------------------------------------------
; Função para ler as linhas pressionadas
; Entrada: Não tem
; Saída: R1 -> Linha pressionada
; Modifica: Nada
Read_Line
	MOV		R1, R0
	AND		R1, #2_00001110
	CMP		R1, #0x00
	BEQ		Line_2
	MOV		R1, #0x01
	BX		LR

Line_2
	MOV		R1, R0
	AND		R1, #2_00001101
	CMP		R1, #0x00
	BEQ		Line_3
	MOV		R1, #0x02
	BX		LR

Line_3
	MOV		R1, R0
	AND		R1, #2_00001011
	CMP		R1, #0x00
	BEQ		Line_4
	MOV		R1, #0x03
	BX		LR

Line_4
	MOV		R1, R0
	AND		R1, #2_00000111
	CMP		R1, #0x00
	BXEQ	LR
	MOV		R1, #0x04
	BX		LR

; -------------------------------------------------------------------------------
; Função PortL_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortL_Input
	LDR		R1, =GPIO_PORTL_DATA_R			;Carrega o valor do offset do data register
	LDR		R0, [R1]						;Lê no barramento de dados dos pinos [J0]
	AND		R0, #2_00001111					;Apenas os pinos PL0, PL1, PL2 e PL3
	BX 		LR								;Retorno

;---------------------------------------------------------------
;------	Decode_Char	--------------------------------------------
; Função para ler as linhas pressionadas
; Entrada: Não tem
; Saída: R1 -> Linha pressionada
; Modifica: Nada
Decode_Char
	BX		LR

	ALIGN
	END