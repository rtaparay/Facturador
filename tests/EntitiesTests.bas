Attribute VB_Name = "EntitiesTests"
Option Explicit

Private Sub RunAllModuleTests()
    un_item_deberia
    una_factura_deberia
End Sub

Private Sub un_item_deberia()
    Dim Item As New ItemEntity

    Item.Quantity = 2
    Item.UnitValue = 50

    With Test.It("calcular su igv")
        .AssertEquals 18, Item.Igv
    End With

    With Test.It("calcular su valor de venta (cantidad * valor unitario)")
        .AssertEquals 100, Item.SaleValue
    End With

    With Test.It("calcular su precio de de venta (cantidad * valor unitario + igv")
        .AssertEquals 118, Item.SalePrice
    End With
End Sub

Private Sub una_factura_deberia()
    Dim Invoice As New InvoiceEntity
    Dim Item1 As New ItemEntity
    Dim Item2 As New ItemEntity

    Item1.Quantity = 2
    Item1.UnitValue = 50

    Item2.Quantity = 4
    Item2.UnitValue = 50

    Invoice.AddItem Item1
    Invoice.AddItem Item2

    With Test.It("tener un valor de venta total igual a la suma del valor de venta de cada item")
        .AssertEquals 300, Invoice.SubTotal
    End With

    With Test.It("tener un IGV igual a la suma del IGV de cada item")
        .AssertEquals 54, Invoice.Igv
    End With

    With Test.It("tener un precio de venta total igual a la suma del precio de venta de cada item")
        .AssertEquals 354, Invoice.Total
    End With
End Sub

Private Sub una_boleta_de_venta_con_total_mayor_a_700_soles_deber�a()
    On Error GoTo HandleErrors
    Dim Invoice As New InvoiceEntity
    Dim Item As New ItemEntity

    Item.Quantity = 1
    Item.UnitValue = 1000
    
    Invoice.DocType = AppDocTypeBoletaVenta
    Invoice.Customer.DocType = AppTypeDocIdentyDNI
    Invoice.Customer.DocNumber = "45184578"
    Invoice.Customer.Name = "APELLIDOS Y NOMBRES"
    Invoice.AddItem Item
    
    Debug.Print Invoice.Total
    Exit Sub

HandleErrors:
    With Test.It("tener informacion del cliente: DNI y apellidos y nombres")
        .AssertEquals AppErrorBVMayor700Soles, Err.Number
    End With
End Sub
