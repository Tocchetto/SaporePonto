Global $enterTimeInput
Global $exitTimeInput
Global $enterTimeInput2
Global $exitTimeInput2
Func editInsertInterface()
   #Region ### START Koda GUI section ### Form=C:\Users\Zelp\Google Drive\Pessoal\Bots\SaporePonto\Interface Editar_Inserir Informacoes Usuario.kxf
   $editInsertGUI = GUICreate("Editar/Inserir Informações do Usuário", 463, 280, 261, 240)
   $userEnterTimeLabel = GUICtrlCreateLabel("Horário de Entrada do Funcionário", 8, 44, 166, 17)
   $enterTimeInput = GUICtrlCreateInput("", 8, 64, 41, 21)
   $exitTimeInput = GUICtrlCreateInput("", 288, 64, 41, 21)
   $enterTimeInput2 = GUICtrlCreateInput("", 8, 176, 41, 21)
   $exitTimeInput2 = GUICtrlCreateInput("", 288, 176, 41, 21)
   $userExitTimeLabel = GUICtrlCreateLabel("Horário de Saída do Funcionário", 288, 40, 158, 17)
   $beforeBreakLabel = GUICtrlCreateLabel("Antes do Intervalo", 184, 16, 90, 17)
   $afterBreakLabel = GUICtrlCreateLabel("Após o Intervalo", 184, 128, 81, 17)
   $userEnterTimeLabel2 = GUICtrlCreateLabel("Horário de Entrada do Funcionário", 8, 148, 166, 17)
   $userExitTimeLabel2 = GUICtrlCreateLabel("Horário de Saída do Funcionário", 288, 152, 158, 17)
   $ExampleLabel = GUICtrlCreateLabel("Ex: 08:32", 56, 68, 49, 17)
   $saveButton = GUICtrlCreateButton("Salvar", 376, 248, 75, 25)
   $resetButton = GUICtrlCreateButton("Limpar", 8, 248, 75, 25)
   $straightLine = GUICtrlCreateLabel("---------------------------------------------------------------------------------------------------------------------------------------------------", 8, 104, 445, 17)
   $obsLabel = GUICtrlCreateLabel("Obs: Para excluir as informações do usuário deixe todos", 96, 208, 267, 17)
   $obsLabel2 = GUICtrlCreateLabel('os campos acima em branco e clique em "salvar".', 120, 224, 240, 17)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   ;Setando os dados dos inputs, testa se os arquivos do usuário para aquele dia existem
   If(FileExists("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada"))Then
	  GUICtrlSetData($enterTimeInput, FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada"))
	  GUICtrlSetData($enterTimeInput2, FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada2"))
	  GUICtrlSetData($exitTimeInput, FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida"))
	  GUICtrlSetData($exitTimeInput2, FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida2"))
   EndIf

   While 1
	  $nMsg = GUIGetMsg()
	  Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			guidelete($editInsertGUI)
			Exitloop
		 Case $saveButton
			;Se não tem nada apaga os horários
			If(GUICtrlRead($enterTimeInput) == "" And GUICtrlRead($exitTimeInput) == "" And GUICtrlRead($enterTimeInput2) == "" And GUICtrlRead($exitTimeInput2) == "") Then
			   deleteUserFiles()
			   guidelete($editInsertGUI)
			   Exitloop
			Else
			   If (validateInput(GUICtrlRead($enterTimeInput)) And validateInput(GUICtrlRead($exitTimeInput)) And validateInput(GUICtrlRead($enterTimeInput2)) And validateInput(GUICtrlRead($exitTimeInput2))) Then
				  editUserFiles()
				  ;Inserir os horarios digitados no input nos arquivos de horarios
				  guidelete($editInsertGUI)
				  Exitloop
			   EndIf
			EndIf
		 Case $resetButton
			resetInputData()
	  EndSwitch
   WEnd
EndFunc

Func resetInputData()
   GUICtrlSetData($enterTimeInput, "")
   GUICtrlSetData($exitTimeInput, "")
   GUICtrlSetData($enterTimeInput2, "")
   GUICtrlSetData($exitTimeInput2, "")
EndFunc

Func validateInput($input)
   $array = StringSplit($input, "")

   If(UBound($array)-1 <> 5)Then ;Testa se o tamanho da entrada é 5
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.")
	  Return False
   ElseIf($array[3] <> ":")Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.")
	  Return False
   EndIf

   If Not(Asc($array[1]) >= 48 And Asc($array[1]) <= 53)Then ;Serve para testar se a entrada é um numero entre 0 e 5
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.1")
	  Return False
   EndIf

   If Not(Asc($array[2]) >= 48 And Asc($array[2]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.2")
	  Return False
   EndIf

   If Not(Asc($array[4]) >= 48 And Asc($array[4]) <= 53)Then ;Serve para testar se a entrada é um numero entre 0 e 5
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.4")
	  Return False
   EndIf

   If Not(Asc($array[5]) >= 48 And Asc($array[5]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.5")
	  Return False
   EndIf

   Return True
EndFunc