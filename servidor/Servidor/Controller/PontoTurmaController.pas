{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Servidor relacionado � tabela [PONTO_TURMA] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2010 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com</p>                                               
                                                                                
@author Albert Eije
@version 1.0                                                                    
*******************************************************************************}
unit PontoTurmaController;

interface

uses
  Classes, SQLExpr, SysUtils, Generics.Collections, Controller, DBXJSON, DBXCommon;

type
  TPontoTurmaController = class(TController)
  protected
  public
    //consultar
    function PontoTurma(pSessao: String; pFiltro: String; pPagina: Integer): TJSONArray;
    //inserir
    function AcceptPontoTurma(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //alterar
    function UpdatePontoTurma(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //excluir
    function CancelPontoTurma(pSessao: String; pId: Integer): TJSONArray;
  end;

implementation

uses
  PontoTurmaVO, T2TiORM, SA;

{ TPontoTurmaController }

var
  objPontoTurma: TPontoTurmaVO;
  Resultado: Boolean;

function TPontoTurmaController.PontoTurma(pSessao, pFiltro: String; pPagina: Integer): TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    Result := TT2TiORM.Consultar<TPontoTurmaVO>(pFiltro, pPagina);
  except
    on E: Exception do
    begin
      Result.AddElement(TJSOnString.Create('ERRO'));
      Result.AddElement(TJSOnString.Create(E.Message));
    end;
  end;

  FSA.MemoResposta.Lines.Clear;
  FSA.MemoResposta.Lines.Add(result.ToString);
end;

function TPontoTurmaController.AcceptPontoTurma(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  UltimoID:Integer;
begin
  objPontoTurma := TPontoTurmaVO.Create(pObjeto);
  Result := TJSONArray.Create;
  try
    try
      UltimoID := TT2TiORM.Inserir(objPontoTurma);
      Result := PontoTurma(pSessao, 'ID = ' + IntToStr(UltimoID), 0);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    objPontoTurma.Free;
  end;
end;

function TPontoTurmaController.UpdatePontoTurma(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  objPontoTurmaOld: TPontoTurmaVO;
begin
 //Objeto Novo
  objPontoTurma := TPontoTurmaVO.Create((pObjeto as TJSONArray).Get(0));
  //Objeto Antigo
  objPontoTurmaOld := TPontoTurmaVO.Create((pObjeto as TJSONArray).Get(1));
  Result := TJSONArray.Create;
  try
    try
      Resultado := TT2TiORM.Alterar(objPontoTurma, objPontoTurmaOld);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    if Resultado then
    begin
      Result.AddElement(TJSONTrue.Create);
    end;
    objPontoTurma.Free;
  end;
end;

function TPontoTurmaController.CancelPontoTurma(pSessao: String; pId: Integer): TJSONArray;
begin
  objPontoTurma := TPontoTurmaVO.Create;
  Result := TJSONArray.Create;
  try
    objPontoTurma.Id := pId;
    try
      Resultado := TT2TiORM.Excluir(objPontoTurma);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    if Resultado then
    begin
      Result.AddElement(TJSONTrue.Create);
    end;
    objPontoTurma.Free;
  end;
end;

end.