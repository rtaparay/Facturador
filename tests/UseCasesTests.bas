Attribute VB_Name = "UseCasesTests"
Option Explicit

Private Sub RunAllModuleTests()
    generar_archivo_json_de_boleta_de_venta_con_un_item
    generar_archivo_json_de_boleta_de_venta_con_dos_items
End Sub

Private Sub generar_archivo_json_de_boleta_de_venta_con_un_item()
    Dim Expected As String
    Dim Cabecera As String
    Dim Detalle As String
    Dim Tributos As String
    Dim Leyendas As String
    Dim Invoice As New InvoiceEntity
    Dim Item As New ItemEntity

    Item.Quantity = 2
    Item.UnitValue = 50
    Item.Code = "CD0001"
    Item.Description = "Producto 1"

    Invoice.EmissionDate = DateValue("30/06/2021")
    Invoice.EmissionTime = TimeValue("10:20:14")
    Invoice.TypeCurrency = "PEN"
    Invoice.AddItem Item

    Cabecera = """cabecera"":{""tipOperacion"":""0101"",""fecEmision"":""2021-06-30"",""horEmision"":""10:20:14"",""fecVencimiento"":""-"",""codLocalEmisor"":""0000"",""tipDocUsuario"":""1"",""numDocUsuario"":""00000000"",""rznSocialUsuario"":""varios"",""tipMoneda"":""PEN"",""sumTotTributos"":""18.00"",""sumTotValVenta"":""100.00"",""sumPrecioVenta"":""118.00"",""sumDescTotal"":""0.00"",""sumOtrosCargos"":""0.00"",""sumTotalAnticipos"":""0.00"",""sumImpVenta"":""118.00"",""ublVersionId"":""2.1"",""customizationId"":""2.0""}"
    Detalle = """detalle"":[{""codUnidadMedida"":""NIU"",""ctdUnidadItem"":""2.00"",""codProducto"":""CD0001"",""codProductoSUNAT"":""-"",""desItem"":""Producto 1"",""mtoValorUnitario"":""50.0000000000"",""sumTotTributosItem"":""18.00"",""codTriIGV"":""1000"",""mtoIgvItem"":""18.00"",""mtoBaseIgvItem"":""100.00"",""nomTributoIgvItem"":""IGV"",""codTipTributoIgvItem"":""VAT"",""tipAfeIGV"":""10"",""porIgvItem"":""18.00"",""mtoPrecioVentaUnitario"":""59.00"",""mtoValorVentaItem"":""100.00""}]"
    Tributos = """tributos"":[{""ideTributo"":""1000"",""nomTributo"":""IGV"",""codTipTributo"":""VAT"",""mtoBaseImponible"":""100.00"",""mtoTributo"":""18.00""}]"
    Leyendas = """leyendas"":[{""codLeyenda"":""1000"",""desLeyenda"":""CIENTO DIECIOCHO CON 00/100 SOLES""}]"
    Expected = "{" & Cabecera & "," & Detalle & "," & Tributos & "," & Leyendas & "}"

    With Test.It("BV con un item")
        .AssertEquals Expected, InvoiceToJson(Invoice, False)
    End With
End Sub

Private Sub generar_archivo_json_de_boleta_de_venta_con_dos_items()
    Dim Expected As String
    Dim Cabecera As String
    Dim Detalle As String
    Dim Tributos As String
    Dim Leyendas As String
    Dim Invoice As New InvoiceEntity
    Dim Item As ItemEntity

    Set Item = New ItemEntity
    Item.Quantity = 2
    Item.UnitValue = 50
    Item.Code = "CD0001"
    Item.Description = "Producto 1"
    Invoice.AddItem Item

    Set Item = New ItemEntity
    Item.Quantity = 5
    Item.UnitValue = 10
    Item.Code = "CD0002"
    Item.Description = "Producto 2"
    Invoice.AddItem Item

    Invoice.EmissionDate = DateValue("30/06/2021")
    Invoice.EmissionTime = TimeValue("10:20:14")
    Invoice.TypeCurrency = "PEN"

    Cabecera = """cabecera"":{""tipOperacion"":""0101"",""fecEmision"":""2021-06-30"",""horEmision"":""10:20:14"",""fecVencimiento"":""-"",""codLocalEmisor"":""0000"",""tipDocUsuario"":""1"",""numDocUsuario"":""00000000"",""rznSocialUsuario"":""varios"",""tipMoneda"":""PEN"",""sumTotTributos"":""27.00"",""sumTotValVenta"":""150.00"",""sumPrecioVenta"":""177.00"",""sumDescTotal"":""0.00"",""sumOtrosCargos"":""0.00"",""sumTotalAnticipos"":""0.00"",""sumImpVenta"":""177.00"",""ublVersionId"":""2.1"",""customizationId"":""2.0""}"
    Detalle = """detalle"":[{""codUnidadMedida"":""NIU"",""ctdUnidadItem"":""2.00"",""codProducto"":""CD0001"",""codProductoSUNAT"":""-"",""desItem"":""Producto 1"",""mtoValorUnitario"":""50.0000000000"",""sumTotTributosItem"":""18.00"",""codTriIGV"":""1000"",""mtoIgvItem"":""18.00"",""mtoBaseIgvItem"":""100.00"",""nomTributoIgvItem"":""IGV"",""codTipTributoIgvItem"":""VAT"",""tipAfeIGV"":""10"",""porIgvItem"":""18.00"",""mtoPrecioVentaUnitario"":""59.00"",""mtoValorVentaItem"":""100.00""},{""codUnidadMedida"":""NIU"",""ctdUnidadItem"":""5.00"",""codProducto"":""CD0002"",""codProductoSUNAT"":""-"",""desItem"":""Producto 2"",""mtoValorUnitario"":""10.0000000000"",""sumTotTributosItem"":""9.00"",""codTriIGV"":""1000"",""mtoIgvItem"":""9.00"",""mtoBaseIgvItem"":""50.00"",""nomTributoIgvItem"":""IGV"",""codTipTributoIgvItem"":""VAT"",""tipAfeIGV"":""10"",""porIgvItem"":""18.00"",""mtoPrecioVentaUnitario"":""11.80"",""mtoValorVentaItem"":""50.00""}]"
    Tributos = """tributos"":[{""ideTributo"":""1000"",""nomTributo"":""IGV"",""codTipTributo"":""VAT"",""mtoBaseImponible"":""150.00"",""mtoTributo"":""27.00""}]"
    Leyendas = """leyendas"":[{""codLeyenda"":""1000"",""desLeyenda"":""CIENTO SETENTA Y SIETE CON 00/100 SOLES""}]"
    Expected = "{" & Cabecera & "," & Detalle & "," & Tributos & "," & Leyendas & "}"

    With Test.It("BV con dos items")
        .AssertEquals Expected, InvoiceToJson(Invoice, False)
    End With
End Sub
