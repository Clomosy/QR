var
  MyForm:TCLForm;
  QRGen : TClQRCodeGenerator;
  QrTimer, QrTimeTimer:TClTimer;
  BtnNewQrCode:TclButton;
  BtnReadQrCode:TclButton;
  ReadQrEdt : TclEdit;
  LblDisplay:TclLabel;
  IntQROnStartVal:Extended;
  QrAppType:Integer;//0:qrgenerator 1:Yonetici 2:Normal User
  QrSecondLimit:Integer;
  
  Procedure QRGenOnGetQRCode;
  begin
    //QRkodun resim olarak saklanması isteniyorsa yada oluştuğu anda event lazım olursa bu event kullanılır
    //Clomosy.GlobalBitmapSaveToFile('x:\GlobalBitmap.png');
  End;
  
  Procedure BtnNewQrCodeClick;
  begin
    BtnNewQrCode.Caption := FormatDateTime('yymmdd0hhnnss', Now);
    QRGen.Text := Clomosy.ProjectEncryptAES(BtnNewQrCode.Caption);
    //BtnNewQrCode.Caption := Clomosy.ProjectEncryptAES(QRGen.Text);
  End;
  Procedure OnQrTimer;
  begin
    QrTimeTimer.Tag := QrSecondLimit;
    BtnNewQrCodeClick;
  End;
  Procedure SaveRecordThread;
  Begin
    Clomosy.DBCloudPostJSON(ftThreads,'[{"Thread_Value_Str":"'+ReadQrEdt.Text+'","Thread_Quantity":1}]');
  End;
  Procedure OnGetQRCode;
    var 
      s:String;
      IntQRVal:Extended;
  begin
    If ReadQrEdt.Text='' Then Exit;
    s := FormatDateTime('yymmdd0hhnnss', Now);
    IntQROnStartVal := StrToFloat(s);//giriş/çıkış yapan kullanıcının işleme başlarkenki telefon saati
    //ShowMessage(IntQROnStartVal);
    Try
      s := Clomosy.ProjectDecryptAES(ReadQrEdt.Text);
      ReadQrEdt.Text := s;
      IntQRVal := StrToFloat(s); //okutulan QR code içinden alınan zaman bilgisi
    Except 
      IntQRVal :=0;
    end;
    //ikisi arasındaki fark QrSecondLimit saniyeden çok olamaz çünkü timer interval degeri ona göre ayarlandı
    //49>59
    If (IntQROnStartVal-QrSecondLimit)<= IntQRVal Then 
    Begin
      //ShowMessage('QRCode Geçerli');
      SaveRecordThread;
    End Else ShowMessage('Geçersiz QR Code. '+IntToStr(QrSecondLimit)+' sn. içinde işlemi tamamlayınız. Tekrar Deneyin.!');
    //ShowMessage(s);
  End;
  Procedure BtnReadQrCodeClick;
  begin
    //MyForm.CallBarcodeReader(ReadQrEdt);
    
    MyForm.CallBarcodeReaderWithScript(ReadQrEdt,'OnGetQRCode');//runs script after read qr code
  End; 
  Procedure OnQrTimeTimer;
  begin
    QrTimeTimer.Tag := QrTimeTimer.Tag - 1;
    LblDisplay.Text := IntToStr(QrTimeTimer.Tag);
  End;
begin
  
  
  QrAppType := 0;//0:qrgenerator 1:Yonetici 2:Normal User
  QrSecondLimit := 10;//tum kontroller 10 sn gore yapılır. sadece buradan deger degistirilerek parametre olur
  
  If Clomosy.PlatformIsMobile Then QrAppType := 2;//0:qrgenerator 1:Yonetici 2:Normal User
  
  If Not Clomosy.PlatformIsMobile Then  //win üzeirinde açılı olan kullanıcı members listesini görsün
    QrAppType := 1;//0:qrgenerator 1:Yonetici 2:Normal User
  IF QrAppType=1 Then 
  Begin
    Clomosy.OpenForm(ftMembers,fdtsingle,froReadOnly, ffoNoFilter);
    Exit;
  End;
    
  if Clomosy.AppUserGUID ='6MFW419738' then
    QrAppType:=1;
  
  If Clomosy.AppUserProfile=1 Then  //proje yönetici ise generator yapıyoruz
   QrAppType:=0;
  //if Clomosy.AppUserGUID ='NX134L18D9' then //Buradan GUID verip generator yapiyoruz
   
  //her 10 sn de ekran QR kodunu degistirir ve istenirse resim olarak saklar
  MyForm := TCLForm.Create(Self);
  
  LblDisplay:= MyForm.AddNewLabel(MyForm,'LblDisplay','--');
  LblDisplay.Align := alTop;
  
  If QrAppType=0 then//QRGenerator ise
  Begin
    QRGen:= MyForm.AddNewQRCodeGenerator(MyForm,'QRGen','Merhaba Dünya');
    QRGen.Height := 200;
    QRGen.Align := alCenter;
    
    BtnNewQrCode:= MyForm.AddNewButton(MyForm,'BtnNewQrCode','Başlıyor');
    BtnNewQrCode.Align := alTop;
    MyForm.AddNewEvent(BtnNewQrCode,tbeOnClick,'BtnNewQrCodeClick');
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
  Begin
    MyForm.AddNewEvent(QRGen,tbeOnGetQRCode,'QRGenOnGetQRCode');
    QrTimer:= MyForm.AddNewTimer(MyForm,'QrTimer',1000*QrSecondLimit);
    QrTimer.Interval := 1000*QrSecondLimit;//10 saniye aralıklarla degisir
    QrTimer.Enabled := True;
    MyForm.AddNewEvent(QrTimer,tbeOnTimer,'OnQrTimer');
  
    QrTimeTimer:= MyForm.AddNewTimer(MyForm,'QrTimeTimer',1000);
    QrTimeTimer.Interval := 1000;//1 saniye aralıklarla sayacı degistirir
    QrTimeTimer.Tag := QrSecondLimit;
    QrTimeTimer.Enabled := True;
    MyForm.AddNewEvent(QrTimeTimer,tbeOnTimer,'OnQrTimeTimer');
  End;
  MyForm.Run;

end;
