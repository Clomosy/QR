(*

Members sayfasinda
Layout Top Text ' e

 [Thread_DateExpl]

Ekliyoruz



*)

var
  MyForm:TCLForm;
  QRGen : TClQRCodeGenerator;
  BtnNewQrCode:TclButton;
  BtnReadQrCode:TclButton;
  ReadQrEdt : TclEdit;
  QrAppType:Integer;//0:qrgenerator 1:Yonetici 2:Normal User

  Procedure BtnNewQrCodeClick;
  begin
    QRGen.Text := Clomosy.ProjectEncryptAES(FormatDateTime('yymmdd0hhnnss', Now));
  End;
  Procedure SaveRecordThread;
  Begin
       Clomosy.DBCloudPostJSON(ftThreads,'[{"Thread_Value_Str":"'+ReadQrEdt.Text+'","Thread_Quantity":1}]');
  End;
  Procedure BtnReadQrCodeClick;
  begin
       MyForm.CallBarcodeReaderWithScript(ReadQrEdt,'SaveRecordThread');//runs script after read qr code
  End; 
begin
  If Clomosy.PlatformIsMobile Then QrAppType := 2;//0:qrgenerator 1:Yonetici 2:Normal User
  
  If Not Clomosy.PlatformIsMobile Then  //win üzeirinde açılı olan kullanıcı members listesini görsün
    QrAppType := 1;//0:qrgenerator 1:Yonetici 2:Normal User
  IF QrAppType=1 Then 
  Begin
    Clomosy.OpenForm(ftMembers,fdtsingle,froReadOnly, ffoNoFilter);
    Exit;
  End;
  If Clomosy.AppUserProfile=1 Then  
     QrAppType:=0;

  MyForm := TCLForm.Create(Self);
  
 
  If QrAppType=0 then//QRGenerator ise
  Begin
    QRGen:= MyForm.AddNewQRCodeGenerator(MyForm,'QRGen','Merhaba Dünya');
    QRGen.Height := 200;
    QRGen.Align := alCenter;
    
  End;
  
  If QrAppType=2 then//QRReader ise Normal User
  Begin
    BtnReadQrCode:= MyForm.AddNewButton(MyForm,'BtnReadQrCode','QRKod Oku');
    BtnReadQrCode.Height := 100;
    BtnReadQrCode.Width := 200;
    BtnReadQrCode.Align := alCenter;
    MyForm.AddNewEvent(BtnReadQrCode,tbeOnClick,'BtnReadQrCodeClick');
    
    ReadQrEdt := MyForm.AddNewEdit(MyForm,'ReadQrEdt','Barkod Okutunuz...');
    ReadQrEdt.Align := alBottom;
    ReadQrEdt.ReadOnly := True;
   ReadQrEdt.Visible := False;
  End;
  
  If QrAppType=0 then
   BtnNewQrCodeClick;
   
  MyForm.Run;

end;
