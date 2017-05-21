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
$MonthCal = GUICtrlCreateMonthCal("2017/05/20", 840, 32, 229, 164)
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
	  $previous = GUICtrlRead($usersList)
	  If Not(GUICtrlRead($usersList) == "") Then ;Esse if serve para quando excluir um funcioonário não ficar bugado a caixa de informações
		 GUICtrlSetData($usersInfoList, "")
		 If FileExists("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-")) Then
			listUserInfo($usersInfoList, $usersList)
		 Else
			GUICtrlSetData($usersInfoList, 'Sem dados para o funcionário "' & GUICtrlRead($usersList) & '" para o dia de hoje!')
			GUICtrlSetData($usersInfoList, 'Clique no botão "Editar/Inserir Informações" para inserir informações para este funcionário.')
		 EndIf
	  EndIf
   EndIf
   GUICtrlRead($MonthCal,2)
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
			   EndIf
			Else
			   MsgBox(0,"Cancelado", "Nenhuma alteração foi feita!")
			EndIf
		 EndIf
	  Case $editUser
		 editInsertInterface()
		 MsgBox(0,GUICtrlRead($usersList),GUICtrlRead($usersList))
		 GUICtrlSetData($usersInfoList, "")
		 $previous = ""
	  Case $MonthCal
		 ConsoleWrite(GUICtrlRead($MonthCal,2))
	EndSwitch
 WEnd

Func listUserInfo($usersInfoList, $usersList)
   GUICtrlSetData($usersInfoList, "Informações do Usuário: " & GUICtrlRead($usersList))
EndFunc

Func createUserFiles()
   DirCreate("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-"))
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-") & "\HorarioEntrada", "")
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-") & "\HorarioEntrada2", "")
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-") & "\HorarioSaida", "")
   FileWrite("funcionarios\" & GUICtrlRead($usersList) & "\" & StringReplace(_NowDate(),"/","-") & "\HorarioSaida2", "")
EndFunc

Func updateInfoUsersList()

EndFunc

Func updateListOfUsers()
   $users = _FileListToArray(@ScriptDir & "\Funcionarios", "*")
   For $i = 1 To UBound($users)-1 Step +1
	  GUICtrlSetData($usersList,$users[$i])
   Next
EndFunc
