#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Date.au3>
#include "Interfaces/editUser.au3"

HotKeySet("{ESC}", "Terminate")

Func Terminate()
   Exit 1
EndFunc

#Region ### START Koda GUI section ### Form=C:\Users\Zelp\Google Drive\Pessoal\Bots\SaporePonto\Interface das Informações de Pesca KODA.kxf
$mainGUI = GUICreate("SaporePonto", 1074, 486, 581, 288)
$usersList = GUICtrlCreateList("", 16, 32, 281, 422)
$usersListLabel = GUICtrlCreateLabel("Lista de Funcionários", 16, 14, 104, 17)
$addUser = GUICtrlCreateButton("Acrescentar Funcionário", 152, 456, 147, 25)
$MonthCal = GUICtrlCreateMonthCal(_NowDate(), 840, 32, 229, 164)
$usersInfoList = GUICtrlCreateList("", 304, 32, 521, 422,BitOr($WS_BORDER, $WS_VSCROLL))
$editUser = GUICtrlCreateButton("Editar/Inserir Informações", 680, 456, 147, 25)
$deleteUser = GUICtrlCreateButton("Excluir", 16, 456, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

updateListOfUsers()
$previous = ""
While 1
   $nMsg = GUIGetMsg()
   If GUICtrlRead($usersList) <> $previous Then
	  updateInfoUsersList()
   EndIf
   Switch $nMsg
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $addUser
		 $userName = InputBox("Acrecentando um Novo Funcionário", "Digite o Nome Completo do Funcionário:", "", "", 300, 126)
		 If FileExists(@ScriptDir & "\Funcionarios\" & $userName) Then
			MsgBox(48,"Erro", "Usuário já existe!")
		 Else
			DirCreate(@ScriptDir & "\Funcionarios\" & $userName)
			If FileExists(@ScriptDir & "\Funcionarios\" & $userName) Then
			   MsgBox(0, "Sucesso", "Usuário criado com sucesso!",1)
			   updateListOfUsers()
			Else
			   MsgBox(0, "Erro", "Usuário erro ao criar funcionário.",1)
			EndIf
		 EndIf
	  Case $deleteUser
		 If GUICtrlRead($usersList) == "" Then
			MsgBox(48,"Erro", "Você precisa selecionar um usuário para excluí-lo!")
		 Else
			$res = MsgBox(1,"Atenção!", "Essa ação não pode ser desfeita e todas as informações do funcionário serão perdidas!")
			If $res == 1 Then
			   If DirRemove(@ScriptDir & "\Funcionarios\" & GUICtrlRead($usersList),1) == 0 Then
				  MsgBox(0,"Erro","Erro ao excluir funcionário, favor notificar o erro para Guilherme Tocchetto (54) 99910-4658")
			   Else
			   GUICtrlSetData($usersList, "")
			   updateListOfUsers()
			   updateInfoUsersList()
			   EndIf
			Else
			   MsgBox(0,"Cancelado", "Nenhuma alteração foi feita!")
			EndIf
		 EndIf
	  Case $editUser
		 If GUICtrlRead($usersList) == "" Then
			MsgBox(48,"Usuário não selecionado", "Selecione um usuário para editar ou inserir informações!")
		 Else
			editInsertInterface()
			GUICtrlSetData($usersInfoList, "")
			$previous = ""
		 EndIf
	  Case $MonthCal
		 updateInfoUsersList()
	EndSwitch
 WEnd

Func listUserInfo($usersInfoList, $usersList)
   $funcTimes = getFuncTimes()
   GUICtrlSetData($usersInfoList, "Informações do Funcionário: " & GUICtrlRead($usersList))
   GUICtrlSetData($usersInfoList, "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
   GUICtrlSetData($usersInfoList, "Horário de Entrada: " & $funcTimes[0])
   GUICtrlSetData($usersInfoList, "Horário de Saída: " & $funcTimes[1])
   GUICtrlSetData($usersInfoList, " ")
   GUICtrlSetData($usersInfoList, "Tempo de Intervalo: " & calculateInterval($funcTimes[1],$funcTimes[2]))
   GUICtrlSetData($usersInfoList, "		")
   GUICtrlSetData($usersInfoList, "Horário de Entrada: " & $funcTimes[2])
   GUICtrlSetData($usersInfoList, "Horário de Saída: " & $funcTimes[3])
   GUICtrlSetData($usersInfoList, "		" & @CRLF)
   GUICtrlSetData($usersInfoList, "Total de Horas Trabalhadas: " & calculateWorkedHours($funcTimes[0],$funcTimes[1],$funcTimes[2],$funcTimes[3]))
   GUICtrlSetData($usersInfoList, "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------" & @CRLF)
   ;Colocar o resto dos dados aqui
EndFunc

;Retorna um vetor com todos os horário do funcionário
Func getFuncTimes()
   Local $funcTimes[4]
   $funcTimes[0] = FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada")
   $funcTimes[1] = FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida")
   $funcTimes[2] = FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada2")
   $funcTimes[3] = FileRead("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida2")
   return $funcTimes
EndFunc

Func calculateInterval($saida, $entrada2)
   $arraySaida = StringSplit($saida, "")
   $arrayEntrada2 = StringSplit($entrada2, "")

   $enterHTime = ($arraySaida[1]*10) + $arraySaida[2]
   $enterMTime = ($arraySaida[4]*10) + $arraySaida[5]
   $outHTime = ($arrayEntrada2[1]*10) + $arrayEntrada2[2]
   $outMTime = ($arrayEntrada2[4]*10) + $arrayEntrada2[5]

   If($outHTime < $enterHTime)Then
	  $IntervalHTime = $outHTime + 24 - $enterHTime
   Else
	  $IntervalHTime = $outHTime - $enterHTime
   EndIf

   If($outMTime < $enterMTime)Then
	  $IntervalHTime = $IntervalHTime - 1
	  $IntervalMTime = $outMTime+60-$enterMTime
   Else
	  $IntervalMTime = $outMTime - $enterMTime
   EndIf

   If($IntervalHTime < 10)Then
	  $IntervalHTime = "0" & $IntervalHTime
   EndIf
   If($IntervalMTime < 10)Then
	  $IntervalMTime = "0" & $IntervalMTime
   EndIf

   Return ($IntervalHTime & ":" & $IntervalMTime)
EndFunc

Func calculateWorkedHours($entrada, $saida, $entrada2, $saida2)
   $arrayEntrada = StringSplit($entrada, "")
   $arraySaida = StringSplit($saida, "")
   $arrayEntrada2 = StringSplit($entrada2, "")
   $arraySaida2 = StringSplit($saida2, "")

   $enterHTime = ($arrayEntrada[1]*10) + $arrayEntrada[2]
   $enterMTime = ($arrayEntrada[4]*10) + $arrayEntrada[5]
   $outHTime = ($arraySaida[1]*10) + $arraySaida[2]
   $outMTime = ($arraySaida[4]*10) + $arraySaida[5]
   $enter2HTime = ($arrayEntrada2[1]*10) + $arrayEntrada2[2]
   $enter2MTime = ($arrayEntrada2[4]*10) + $arrayEntrada2[5]
   $out2HTime = ($arraySaida2[1]*10) + $arraySaida2[2]
   $out2MTime = ($arraySaida2[4]*10) + $arraySaida2[5]

   If($outHTime < $enterHTime)Then
	  $difHTimeBeforeInterval = $outHTime + 24 - $enterHTime
   Else
	  $difHTimeBeforeInterval = $outHTime - $enterHTime
   EndIf

   If($outMTime < $enterMTime)Then
	  $difHTimeBeforeInterval = $difHTimeBeforeInterval - 1
	  $difMTimeBeforeInterval = $outMTime + 60 - $enterMTime
   Else
	  $difMTimeBeforeInterval = $outMTime - $enterMTime
   EndIf

	  ;ConsoleWrite("Time Worked Before Interval: " & $difHTimeBeforeInterval & ":" & $difMTimeBeforeInterval & @CRLF)

   If($out2HTime < $enter2HTime)Then
	  $difHTimeAfterInterval = $out2HTime + 24 - $enter2HTime
   Else
	  ;ConsoleWrite("$out2HTime: " & $out2HTime & " $enter2HTime: " & $enter2HTime & @CRLF)
	  $difHTimeAfterInterval = $out2HTime - $enter2HTime
	  ;ConsoleWrite("$difHTimeAfterInterval: " & $difHTimeAfterInterval & @CRLF)
   EndIf

   If($out2MTime < $enter2MTime)Then
	  $difHTimeAfterInterval = $difHTimeAfterInterval - 1
	  $difMTimeAfterInterval = $out2MTime + 60 - $enter2MTime
   Else
	  $difMTimeAfterInterval = $out2MTime - $enter2MTime
   EndIf

	  ;ConsoleWrite("Time Worked After Interval: " & $difHTimeAfterInterval & ":" & $difMTimeAfterInterval & @CRLF)

   $workedH = $difHTimeBeforeInterval + $difHTimeAfterInterval
   $workedM = $difMTimeBeforeInterval + $difMTimeAfterInterval
   While $workedM > 59
	  $workedM = $workedM - 60
	  $workedH = $workedH + 1
   WEnd



   if($workedH < 10) Then
	  $workedH = "0" & $workedH
   EndIf
   If($workedM < 10)Then
	  $workedM = "0" & $workedM
   EndIf

   Return($workedH & ":" & $workedM)
EndFunc

Func createUserFiles()
   DirCreate("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-"))
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada", GUICtrlRead($enterTimeInput))
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioEntrada2", GUICtrlRead($enterTimeInput2))
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida", GUICtrlRead($exitTimeInput))
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-") & "\HorarioSaida2", GUICtrlRead($exitTimeInput2))
EndFunc

Func updateInfoUsersList()
   $previous = GUICtrlRead($usersList)
   If (GUICtrlRead($usersList) == "") Then ;Esse if serve para quando excluir um funcioonário não ficar bugado a caixa de informações
	  GUICtrlSetData($usersInfoList, "")
   EndIf

   If Not(GUICtrlRead($usersList) == "") Then
	  GUICtrlSetData($usersInfoList, "")
	  If FileExists("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(GUICtrlRead($MonthCal,2),"/","-")) Then
		 listUserInfo($usersInfoList, $usersList)
	  Else
		 GUICtrlSetData($usersInfoList, 'Sem dados para o funcionário "' & GUICtrlRead($usersList) & '" para o dia ' & GUICtrlRead($MonthCal,2))
		 GUICtrlSetData($usersInfoList, 'Clique no botão "Editar/Inserir Informações" para inserir informações para este funcionário.')
	  EndIf
   EndIf
EndFunc

Func updateListOfUsers()
   $users = _FileListToArray(@ScriptDir & "\Funcionarios", "*")
   For $i = 1 To UBound($users)-1 Step +1
	  GUICtrlSetData($usersList,$users[$i])
   Next
EndFunc
