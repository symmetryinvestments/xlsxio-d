module xlsxio;

/*****************************************************************************
Copyright (C)  2016  Brecht Sanders  All Rights Reserved
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*****************************************************************************/


import core.stdc.time: time_t;

version(XmlUnicode)
{
	alias wchar_t = wchar;
	alias XLSXIOCHAR = wchar_t;
	pragma(msg, "building with XLSXIOCHAR as wchar");
}
else
{
	alias XLSXIOCHAR = char;
	pragma(msg, "building with XLSXIOCHAR as char");
}


extern(C) @nogc nothrow:
struct xlsxio_read_struct;
struct xlsxio_read_sheet_struct;
struct xlsxio_read_sheetlist_struct;
struct xlsxio_write_struct;

void xlsxioread_get_version (int* pmajor, int* pminor, int* pmicro);
const(XLSXIOCHAR)* xlsxioread_get_version_string ();
alias xlsxioreader = xlsxio_read_struct*;
xlsxioreader xlsxioread_open (const(char*) filename);
xlsxioreader xlsxioread_open_filehandle (int filehandle);
xlsxioreader xlsxioread_open_memory (void* data, ulong datalen, int freedata);
void xlsxioread_close (xlsxioreader handle);
alias xlsxioread_list_sheets_callback_fn = int function(const(XLSXIOCHAR)* name, void* callbackdata);
void xlsxioread_list_sheets (xlsxioreader handle, xlsxioread_list_sheets_callback_fn callback, void* callbackdata);

enum XLSXIOREAD_SKIP_NONE           = 0;
enum XLSXIOREAD_SKIP_EMPTY_ROWS      = 0x01;
enum XLSXIOREAD_SKIP_EMPTY_CELLS     = 0x02;
enum XLSXIOREAD_SKIP_ALL_EMPTY       = (XLSXIOREAD_SKIP_EMPTY_ROWS | XLSXIOREAD_SKIP_EMPTY_CELLS);
enum XLSXIOREAD_SKIP_EXTRA_CELLS     = 0x04;
alias xlsxioread_process_cell_callback_fn = int function(size_t row, size_t col, const(XLSXIOCHAR)* value, void* callbackdata);
alias xlsxioread_process_row_callback_fn = int function(size_t row, size_t maxcol, void* callbackdata);
int xlsxioread_process (xlsxioreader handle, const(XLSXIOCHAR)* sheetname, uint flags, xlsxioread_process_cell_callback_fn cell_callback, xlsxioread_process_row_callback_fn row_callback, void* callbackdata);
alias xlsxioreadersheetlist = xlsxio_read_sheetlist_struct*;
xlsxioreadersheetlist xlsxioread_sheetlist_open (xlsxioreader handle);
void xlsxioread_sheetlist_close (xlsxioreadersheetlist sheetlisthandle);
const(XLSXIOCHAR)* xlsxioread_sheetlist_next (xlsxioreadersheetlist sheetlisthandle);
alias xlsxioreadersheet = xlsxio_read_sheet_struct*;
xlsxioreadersheet xlsxioread_sheet_open (xlsxioreader handle, const(XLSXIOCHAR)* sheetname, uint flags);
void xlsxioread_sheet_close (xlsxioreadersheet sheethandle);
int xlsxioread_sheet_next_row (xlsxioreadersheet sheethandle);
XLSXIOCHAR* xlsxioread_sheet_next_cell (xlsxioreadersheet sheethandle);
int xlsxioread_sheet_next_cell_string (xlsxioreadersheet sheethandle, XLSXIOCHAR** pvalue);
int xlsxioread_sheet_next_cell_int (xlsxioreadersheet sheethandle, long* pvalue);
int xlsxioread_sheet_next_cell_float (xlsxioreadersheet sheethandle, double* pvalue);
int xlsxioread_sheet_next_cell_datetime (xlsxioreadersheet sheethandle, time_t* pvalue);
void xlsxiowrite_get_version (int* pmajor, int* pminor, int* pmicro);
const(char)* xlsxiowrite_get_version_string ();
alias xlsxiowriter = xlsxio_write_struct*;
xlsxiowriter xlsxiowrite_open (const(char)* filename, const(char)* sheetname);
int xlsxiowrite_close (xlsxiowriter handle);
void xlsxiowrite_set_detection_rows (xlsxiowriter handle, size_t rows);
void xlsxiowrite_set_row_height (xlsxiowriter handle, size_t height);
void xlsxiowrite_add_column (xlsxiowriter handle, const(char)* name, int width);
void xlsxiowrite_add_cell_string (xlsxiowriter handle, const(char)* value);
void xlsxiowrite_add_cell_int (xlsxiowriter handle, long value);
void xlsxiowrite_add_cell_float (xlsxiowriter handle, double value);
void xlsxiowrite_add_cell_datetime (xlsxiowriter handle, time_t value);
void xlsxiowrite_next_row (xlsxiowriter handle);
