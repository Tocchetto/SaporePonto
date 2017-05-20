#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

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
$usersInfoList = GUICtrlCreateList("", 304, 32, 521, 422)
$editUser = GUICtrlCreateButton("Editar/Inserir Informações", 680, 456, 147, 25)
$deleteUser = GUICtrlCreateButton("Excluir", 16, 456, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

updateListOfUsers()

While 1
   $nMsg = GUIGetMsg()
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
			   DirRemove(@ScriptDir & "\Funcionarios\" & GUICtrlRead($usersList))
			   GUICtrlSetData($usersList, "")
			   updateListOfUsers()
			Else
			   MsgBox(0,"Cancelado", "Nenhuma alteração foi feita!")
			EndIf
		 EndIf
	EndSwitch
 WEnd

Func updateListOfUsers()
   $users = _FileListToArray(@ScriptDir & "\Funcionarios", "*")
   For $i = 1 To UBound($users)-1 Step +1
	  GUICtrlSetData($usersList,$users[$i])
   Next
EndFunc
