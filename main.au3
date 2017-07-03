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
   GUICtrlSetData($usersInfoList, "Horário de Entrada: " & $funcTimes[0])
   GUICtrlSetData($usersInfoList, "Horário de Saída: " & $funcTimes[1])
   GUICtrlSetData($usersInfoList, "Tempo de Intervalo: " & calculateInterval($funcTimes[0],$funcTimes[1],$funcTimes[2],$funcTimes[3]))
   GUICtrlSetData($usersInfoList, "Horário de Entrada: " & $funcTimes[2])
   GUICtrlSetData($usersInfoList, "Horário de Saída: " & $funcTimes[3])
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

Func calculateInterval($entrada, $saida, $entrada2, $saida2)
   $arrayEntrada1 = StringSplit($entrada, "")
   $arraySaida1 = StringSplit($saida, "")

   $enterHTime = ($arrayEntrada1[1]*10) + $arrayEntrada1[2]
   $enterMTime = ($arrayEntrada1[4]*10) + $arrayEntrada1[5]
   $outHTime = ($arraySaida1[1]*10) + $arraySaida1[2]
   $outMTime = ($arraySaida1[4]*10) + $arraySaida1[5]

   ConsoleWrite("EnterTime: " & $enterHTime & @CRLF)
   ConsoleWrite("OutTime: " & $outHTime & @CRLF)
   ConsoleWrite("OutTime-EnterTime: " & $outHTime-$enterHTime & @CRLF)

   $IntervalHTime = $outHTime - $enterHTime
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

Func calculateWorkedHours()

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
