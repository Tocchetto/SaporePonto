Func editInsertInterface()
   #Region ### START Koda GUI section ### Form=C:\Users\Zelp\Google Drive\Pessoal\Bots\SaporePonto\Interface Editar_Inserir Informacoes Usuario.kxf
   $editInsertGUI = GUICreate("Editar/Inserir Informações do Usuário", 463, 200, 954, 298)
   $userEnterTimeLabel = GUICtrlCreateLabel("Horário de Entrada do Funcionário", 8, 44, 166, 17)
   Global $enterTimeInput = GUICtrlCreateInput("", 8, 64, 41, 21)
   $userExitTimeLabel = GUICtrlCreateLabel("Horário de Saída do Funcionário", 8, 96, 158, 17)
   Global $exitTimeInput = GUICtrlCreateInput("", 8, 120, 41, 21)
   $beforeBreakLabel = GUICtrlCreateLabel("Antes do Intervalo", 48, 16, 90, 17)
   $afterBreakLabel = GUICtrlCreateLabel("Após o Intervalo", 312, 16, 81, 17)
   $userEnterTimeLabel2 = GUICtrlCreateLabel("Horário de Entrada do Funcionário", 288, 44, 166, 17)
   Global $enterTimeInput2 = GUICtrlCreateInput("", 288, 64, 41, 21)
   $userExitTimeLabel2 = GUICtrlCreateLabel("Horário de Saída do Funcionário", 288, 96, 158, 17)
   Global $exitTimeInput2 = GUICtrlCreateInput("", 288, 120, 41, 21)
   $ExampleLabel = GUICtrlCreateLabel("Ex: 08:32", 56, 68, 49, 17)
   $insertUserButton = GUICtrlCreateButton("Inserir", 192, 152, 75, 25)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   While 1
	  $nMsg = GUIGetMsg()
	  Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			guidelete($editInsertGUI)
			Exitloop
		 Case $insertUserButton
			If (validateInput(GUICtrlRead($enterTimeInput)) And validateInput(GUICtrlRead($exitTimeInput)) And validateInput(GUICtrlRead($enterTimeInput2)) And validateInput(GUICtrlRead($exitTimeInput2))) Then
			   createUserFiles()
			   ;Inserir as horarios digitados no input nos arquivos de horarios
			   guidelete($editInsertGUI)
			   Exitloop
			EndIf
	  EndSwitch
   WEnd
EndFunc

Func validateInput($input)
   $array = StringSplit($input, "")

   If(UBound($array)-1 <> 5)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.")
	  Return False
   ElseIf($array[3] <> ":")Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.")
	  Return False
   EndIf

   If Not(Asc($array[1]) >= 48 And Asc($array[1]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.1")
	  Return False
   EndIf

   If Not(Asc($array[2]) >= 48 And Asc($array[2]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.2")
	  Return False
   EndIf

   If Not(Asc($array[4]) >= 48 And Asc($array[4]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.4")
	  Return False
   EndIf

   If Not(Asc($array[5]) >= 48 And Asc($array[5]) <= 57)Then
	  MsgBox(48, "Erro", "Por favor, confira o formato de hora que você está inserindo e tente novamente.5")
	  Return False
   EndIf

   Return True
EndFunc