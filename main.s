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
MSG_STATE_01_ROW_01		DCB			"Cofre Aberto    ",0
MSG_STATE_01_ROW_02		DCB			"Nova Senha:     ",0
MSG_STATE_02_ROW_01		DCB			"Cofre Fechando  ",0
MSG_STATE_02_ROW_02		DCB			"                ",0
MSG_STATE_03_ROW_01		DCB			"Cofre Fechado   ",0
MSG_STATE_03_ROW_02		DCB			"                ",0
MSG_STATE_04_ROW_01		DCB			"Cofre Abrindo   ",0
MSG_STATE_04_ROW_02		DCB			"                ",0
MSG_STATE_05_ROW_01		DCB			"Cofre Travado   ",0
MSG_STATE_05_ROW_02		DCB			"                ",0
MSG_STATE_06_ROW_01		DCB			"Nova SenhaMestre",0
MSG_STATE_06_ROW_02		DCB			"digite:         ",0
MSG_STATE_07_ROW_01		DCB			"Digite a Senha  ",0
MSG_STATE_07_ROW_02		DCB			"Mestre:         ",0


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
		IMPORT	Decode_Char

; -------------------------------------------------------------------------------
Start  		
	BL 		PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL 		SysTick_Init
	BL 		GPIO_Init                 	;Chama a subrotina que inicializa os GPIO
	BL		LCD_Init
	MOV		R5, #0						;registrador de confirmação do envio da senha
	MOV		R6, #0						;password que o usuário digito	
	MOV		R7, #0						;SW1 Acionado
	MOV		R8, #0						;SW2 Acionado
	MOV		R9, #0						;Password Usuario para abrir o cofre
	MOV		R10, #0						;Quantidade de Erros de senha
	MOV		R11, #0						;Registrador do estado anterior
	MOV		R12, #2						;Registrador do estado atual
	B		begin_here
; -------------------------------------------------------------------------------
; Função main()
Main
	BL	Read_Keyboard
	BL	Decode_Char
	B	Main

	BL		State_Transition_Machine;	;Função de Transição de Estado
	CMP 	R11, R12					;Comparando se o estado anterior é igual ao estado atual
	BEQ		Main						;So sai por interrupção ou leitura
begin_here
State_1_lcd								;“Cofre aberto, digite nova senha para fechar o cofre”.
	CMP 	R12, #1
	BNE 	State_2_lcd					;Se R12 diferente de 1 ele salta para o Estado 2
	BL 		State_1_exe
	MOV		R11,R12						;Atualizo estado anterior
	B		Main
State_2_lcd								;“Cofre fechando”
	CMP 	R12, #2
	BNE 	State_3_lcd					;Se R12 diferente de 1 ele salta para o Estado 3
	BL 		State_2_exe
	MOV		R11,R12						;Atualizo estado anterior
	B		Main
State_3_lcd								;“Cofre fechado”
	CMP 	R12, #3
	BNE 	State_4_lcd					;Se R12 diferente de 1 ele salta para o Estado 4
	BL 		State_3_exe
	MOV		R11,R12						;Atualizo estado anterior
	B		Main
State_4_lcd								;“Cofre abrindo”
	CMP 	R12, #4
	BNE 	State_5_lcd					;;Se R12 diferente de 1 ele salta para o Estado 5
	BL 		State_4_exe
	MOV		R11,R12						;Atualizo estado anterior
	B		Main
State_5_lcd								;“Cofre Travado”
	CMP		R12, #5
	BNE		State_6_lcd					;Se R12 diferente de 1 ele salta para o Estado 6
	BL		State_5_exe					;
	MOV		R11,R12						;Atualizo estado anterior
	B		Main
State_6_lcd								;"Nova Senha Mestre"
	CMP		R12, #6
	BNE		State_7_lcd
	BL		State_6_exe
	B		Main		
State_7_lcd
	CMP		R12, #7
	BNE		Main
	BL		State_7_exe
	B		Main
; --------------------------Funções-----------------------------------
;------------Satate_Transition_Machine------------
; Função com objetivo de controlar as transições de estados do cofre
; Entrada: R5, R6, R7, R8, R9, R10, R12
; Saída: Não tem
; Modifica: R0, R1, R2, R8, R10, R12
State_Transition_Machine
										; Leitura do Teclado Matricial
										; Possivelmente printa a senha no lcd
State_1
	CMP		R12, #1						; Compara se esta no Estado 1
	BNE		State_2						; Salta para verificar se está no estado 2					
	MOV		R10, #0						; Zera os erros de senha
	CMP		R8, #1						; Compara se SW2 foi pressionado
	BNE		SW2_not_pressed_1			; 
	MOV		R12, #6						; State 1(Cofre Aberto) -> State 6(Nova Senha Mestre)
	MOV		R8, #0;						; Executou o que estava na chave Sw2
SW2_not_pressed_1
	PUSH	{LR}
	BL 		CheckNewPassword			; Checar o password tendo como retorno R0 como flag
	POP		{LR}
	CMP		R0, #1						; Compara se a Senha valida é salva
	BNE		End_Machine					; 
	MOV		R12, #2						; State 1(Cofre Aberto) -> State 2(Cofre Fechando)
	
	MOV		R1, #0						; registrador de acumulo para passar 1s
	MOV		R0, #1						; entrada da função SysTick_Wait1ms
wait_1s
	ADD		R1,R1,#1
	PUSH	{LR}
	BL		SysTick_Wait1ms
	POP		{LR}
	CMP		R8, #1						; Compara se SW2 foi pressionado
	BEQ		SW2_pressed_1
	CMP		R1, #1000
	BNE		wait_1s
	B		End_Machine
	
SW2_pressed_1
	MOV		R12, #6						; State 1(Cofre Aberto) -> State 6(Nova Senha Mestre)
	MOV		R8, #0						; Executou o que estava na chave Sw2
	B		End_Machine
State_2
	CMP		R12, #2
	BNE		State_3						; Salta para verificar se está no estado 3
	PUSH	{LR}
	MOV		R0, #5000					; Espera 5s para mudar de estado
	BL		SysTick_Wait1ms
	POP		{LR}
	MOV		R12, #3						; State 2(Cofre Fechando) -> State 3(Cofre Fechado)
	B		End_Machine
State_3
	CMP		R12, #3
	BNE		State_4						; Salta para verificar se está no estado 2
	CMP		R8, #1						; Verificar se SW2 precisa ser executado
	BNE		SW2_Not_Pressed_3
	MOV		R12, #6;					; State 3(Cofre Fechado) -> State 6(Nova Senha Mestre)
	MOV		R8, #0;						; Executou o que estava na chave Sw2
	B		End_Machine					; Sai da Máquina
SW2_Not_Pressed_3
	PUSH	{LR}
	BL		CheckPassword				; Verifico se o Password esta correto ], caso contrario incremento R10 ou nada se '#' n ter sido pressionado. Usar R0 se a senha foi digita certa
	POP		{LR}
	CMP		R0, #1						; 
	BNE		Incorrect_Password_3		; Salta para Verificar Se teve 3 Erros
	MOV		R12, #4						; State 3(Cofre Fechado) -> State 4(Cofre Abrindo)
	B		End_Machine
Incorrect_Password_3
	CMP		R10, #3						; Compara se passou de todas quantidades de erro
	BNE		did_not_exceed_the_error_limit
	MOV		R12, #5						; State 3(Cofre Fechado) -> State 5(Cofre Travado)
did_not_exceed_the_error_limit
	B		End_Machine
	;
State_4
	CMP		R12, #4
	BNE		State_5
	PUSH	{LR}
	MOV		R0, #5000					; Espera os 5s
	BL		SysTick_Wait1ms
	POP{LR}
	MOV		R12, #1						; State 4(Cofre Abrindo) -> State 1(Cofre Aberto)
	B		End_Machine
State_5
	CMP		R12, #5						
	BNE		State_6						; Salta para verificar se está no estado 6
	CMP		R7, #1						;
	BNE		Sw1_Not_Pressed_5
	MOV		R12, #7						; State 5(Cofre Travado) -> State 7(Solicitação da Senha Mestre)
	B		End_Machine
Sw1_Not_Pressed_5
	B		State_5						; salta para o estado 5 e só sai se SW1 for pressionado(Não precisa conferir a leitura do teclado matricial)
State_6
	CMP		R12, #6
	BNE		State_7
	PUSH	{LR}
	BL		CheckNewMasterPassword		; Verifica se o MasterPassword digitado é valido e retorna 1 se Checagem for valida
	POP		{LR}
	CMP		R0, #1
	BNE		Incorrect_MasterPassword_6
	MOV		R12, R11;					; State 6(Solicitação de uma Nova Senha) -> State 1(Cofre Aberto) || State 3(Cofre Fechado)
Incorrect_MasterPassword_6
	B		End_Machine
State_7
	CMP		R12, #7
	BNE		End_Machine
	PUSH	{LR}
	BL		CheckMasterPassword			; Verifica se MasterPassaword é valido e se sim retorna R0=1 se Não retorna R0=0
	POP		{LR}
	CMP		R0, #1
	BNE		Invalid_MasterPassword
	MOV		R12, #4						; State 7(Solicitação da Senha Mestre) -> State 4(Cofre Abrindo)
Invalid_MasterPassword
End_Machine
	BX		LR							;retorno State_Transition_Machine
;------------State_1_exe------------
; Função para imprimir no LCD o Estado 1 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_1_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_01_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_01_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_2_exe------------
; Função para imprimir no LCD o Estado 2 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_2_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_02_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_02_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_3_exe------------
; Função para imprimir no LCD o Estado 3 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_3_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_03_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_03_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_4_exe------------
; Função para imprimir no LCD o Estado 4 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_4_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_04_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_04_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_5_exe------------
; Função para imprimir no LCD o Estado 5 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_5_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_05_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_05_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_6_exe------------
; Função para imprimir no LCD o Estado 6 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_6_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_06_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_06_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
;------------State_7_exe------------
; Função para imprimir no LCD o Estado 7 do Cofre
; Entrada: Não Tem 
; Saída: Não Tem
; Modifica: Nada
State_7_exe
	PUSH	{R0}
	PUSH	{LR}
	BL		LCD_Reset
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_07_ROW_01
	BL		LCD_Write_String
	POP		{LR}
	PUSH	{LR}
	MOV		R0, #0xC0 
	BL		LCD_Move_Cursor
	POP		{LR}
	PUSH	{LR}
	LDR		R0, =MSG_STATE_07_ROW_02
	BL		LCD_Write_String
	POP		{LR}
	POP		{R0}
	BX		LR
; Funções a serem feitas:
;------------CheckNewPassword------------
; Função para checar o password é valido
; Entrada: R5, R6
; Saída: R0(0 = password invalido ou nao sem  '#' / 1 = para password válido)
; Modifica: R9(Password do usuário)
CheckNewPassword
	BX		LR
;------------CheckPassword------------
; Função verificar se o Password esta correto, caso contrario incremento R10 ou nada se '#' n ter sido pressionado. Usar R0 se a senha foi digita certa
; Entrada: R5, R6, R9
; Saída: R0(0 = password invalido ou nao sem  '#' / 1 = para password válido)
; Modifica: 
CheckPassword
	BX		LR
;------------CheckNewMasterPassword------------
; Função verificar se o Password digitado é valido e retorna 1 se Checagem for valida se for salva tbm no endereço MASTERPASSWORD
; Entrada: R5, R6
; Saída: R0(0 = password invalido ou nao sem  '#' / 1 = para password válido)
; Modifica: 
CheckNewMasterPassword
	BX		LR
;------------CheckMasterPassword------------
; Função verificar se MasterPassaword é valido e se sim retorna R0=1 se Não retorna R0=0
; Entrada: R5, R6
; Saída: R0(0 = password invalido ou nao sem  '#' / 1 = para password válido)
; Modifica: 
CheckMasterPassword
	BX		LR					;Chama a subrotina que inicializa o LCD
;--------------------------------------------------------------------------------
Fim
	NOP;
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
