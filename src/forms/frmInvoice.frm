VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmInvoice 
   ClientHeight    =   6645
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   10170
   OleObjectBlob   =   "frmInvoice.frx":0000
   StartUpPosition =   1  'Centrar en propietario
End
Attribute VB_Name = "frmInvoice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub UserForm_Initialize()
    frmInvoice.Caption = "BOLETA DE VENTA"
    txtEmissionDate = Format(Date, "dd/mm/yyyy")
    cboTypeCurrency.List = Array("Soles", "D�lares")
    lblIGVTitle = "IGV " & Format(Prop.Rate.Igv * 100) & "%:"
End Sub

Private Sub cboTypeCurrency_Change()
    FrmInvoiceShowInformation
End Sub

Private Sub cmdAddProduct_Click()
    frmAddProduct.Show
End Sub

Private Sub lstItems_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    On Error Resume Next
    Dim Question As Integer

    If lstItems.ListCount < 1 Then Exit Sub

    If KeyCode = 46 Then
        lstItems.RemoveItem lstItems.ListIndex
    End If

    FrmInvoiceShowInformation
End Sub

Private Sub cmdSave_Click()
    On Error GoTo HandleErrors
    Dim Invoice As New InvoiceEntity
    Dim Item As ItemEntity
    Dim Row As Integer

    If Not FieldsValid Then Exit Sub
    
    Invoice.EmissionDate = DateValue(txtEmissionDate)
    Invoice.EmissionTime = Time
    If cboTypeCurrency = "Soles" Then Invoice.TypeCurrency = AppTypeCurrencyPEN
    If cboTypeCurrency = "D�lares" Then Invoice.TypeCurrency = AppTypeCurrencyUSD
    
    With frmInvoice.lstItems
        For Row = 0 To .ListCount - 1
            Set Item = New ItemEntity
            Item.Code = "1000"
            Item.Description = Trim(.List(Row, 0))
            Item.Quantity = .List(Row, 1)
            Item.UnitValue = TaxLess(.List(Row, 2), Prop.Rate.Igv)
            
            Invoice.AddItem Item
        Next Row
    End With

    Debug.Print InvoiceToJson(Invoice)

    MsgBox "El documento electr�nico se gener� correctamente.", vbInformation, "Documento generado"
    Unload Me
    Exit Sub
    
HandleErrors:
    MsgBox Err.Description, vbCritical, "Debe ingresar los datos del cliente."
End Sub

Private Function FieldsValid() As Boolean
    If txtDocNumber = Empty Then
        MsgBox "Debe ingresar el n�mero del comprobante.", vbInformation, "N�mero de documento"
        txtDocNumber.SetFocus
        Exit Function
    End If
    If lstItems.ListCount < 1 Then
        MsgBox "Debe ingresar al menos un producto.", vbInformation, "Ingrese productos"
        Exit Function
    End If
    
    FieldsValid = True
End Function

Private Sub cmdCancel_Click()
    Unload Me
End Sub
