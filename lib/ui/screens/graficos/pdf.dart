import 'dart:convert';
import 'dart:html';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../models/usuario.dart';
import '../../../models/ejercicio.dart';
import 'fileSave.dart';

class Pdf {
  final Usuario alumno;
  final List<Ejercicio> ejercicios;
  final int tiempoMeses;
  final String tipoEjercicio;
  final String dificultad;
  Pdf(this.alumno, this.ejercicios, this.tiempoMeses, this.tipoEjercicio, this.dificultad);

  Future<void> generatePDF() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(page, pageSize, grid);
    //Draw grid
    _drawGrid(page, grid, result);
    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    await FileSaveHelper.saveAndLaunchFile(bytes, alumno.apellidos+' '+alumno.nombre+' '+formattedDate+'.pdf');
  }

  //Draws the invoice header
  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
    //Draw string
    page.graphics.drawString(
        'Informe', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Create data foramt and convert it to text.
    initializeDateFormatting();
    final DateFormat format = DateFormat.yMMMMd('es');
    final String fechaInforme = 'Fecha: ' +
        format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(fechaInforme);
    String alumnoInforme =
        'Informe correspondiente al alumno: \r\n\r\n' + alumno.nombre + ' ' + alumno.apellidos + 
        ', \r\n\r\nEmail: '+alumno.email+' \r\n\r\nDuranción del informe: '+ tiempoMeses.toString()+ ' meses'
        ' \r\n\r\nTipo de ejercicio: '+tipoEjercicio+' \r\n\r\nDificultad: '+dificultad;
    PdfTextElement(text: fechaInforme, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
    return PdfTextElement(text: alumnoInforme, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Fecha';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Letras correctas';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Aciertos';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[3].value = 'Errores';
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[4].value = 'Duración';
    headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
    for (Ejercicio ejercicio in ejercicios){
      _addProducts(ejercicio, grid);
    }
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void _addProducts(Ejercicio ejercicio, PdfGrid grid) {
    Duration _duracion = ejercicio.dateFin.difference(ejercicio.dateInicio);
    String formattedDate = DateFormat('dd-MM-yyyy').format(ejercicio.dateFin);

    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = formattedDate;
    row.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[1].value = ejercicio.letrasCorrectas.toString();
    row.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[2].value = ejercicio.aciertos.toString();
    row.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[3].value = ejercicio.errores.toString();
    row.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[4].value = _duracion.toString();
    row.cells[4].stringFormat.alignment = PdfTextAlignment.center;
    
  }

}



