var
  MyForm:TCLForm;
  //YÖNETİCİ EKRANI
  mainPnl : TclProPanel;
  timeContainer : TclLayout;
  CaptionLbl,timeCaptionLbl,timeLbl : TClProLabel;
  QRGen : TClQRCodeGenerator;
  //KULLANICI EKRANI
  descriptionLbl : TClProLabel;
  BtnReadQrCode:TclProButton;
  ReadQrEdt : TclEdit;
  QrAppType:Integer;  //0:qrgenerator 1:Yonetici 2:Normal User
  GetTimer: TClTimer;

  procedure BtnNewQrCodeClick
  begin
    QRGen.Text :=  FormatDateTime('hhnn', Now);
    timeLbl.Text := FormatDateTime('hh', Now) + ':' +FormatDateTime('nn', Now);
  end;
  procedure SaveRecordThread
  begin
    if ReadQrEdt.Text = IntToStr(FormatDateTime('hhnn', Now)) then
    begin
      Clomosy.DBCloudPostJSON(ftThreads,'[{"Thread_Value_Str":"'+ReadQrEdt.Text+'","Thread_Quantity":1}]');
      BtnReadQrCode.Text :='Okutuldu...';
      descriptionLbl.Text := 'Qr kod okutma işlemi başarılı. Windows ekranına giriş saatiniz eklenmiştir.';
      clComponent.SetupComponent(descriptionLbl,'{"TextColor":"#12b021"}');
      BtnReadQrCode.Enabled := False;
    end; else
    begin
      ShowMessage('Yanlış! Lütfen, tekrar deneyiniz..');
    end;
  end;
  procedure BtnReadQrCodeClick
  begin
    MyForm.CallBarcodeReaderWithScript(ReadQrEdt,'SaveRecordThread');//runs script after read qr code
  end;
  procedure timerShow
  begin
    BtnNewQrCodeClick;
  end;
  procedure adminScreen
  begin
    timeContainer := MyForm.AddNewLayout(mainPnl,'timeContainer');
    timeContainer.Align:=AlTop;
    timeContainer.Height := 50;
    timeContainer.Margins.Left  := 20;
    timeContainer.Margins.Top := 50;
    
    timeCaptionLbl := MyForm.AddNewProLabel(timeContainer,'timeCaptionLbl','SAAT > ');
    clComponent.SetupComponent(timeCaptionLbl,'{"Align" : "MostLeft","Width" :90,"TextColor":"#90646D",
    "TextSize":26,"TextVerticalAlign":"center","TextHorizontalAlign":"left","TextBold":"yes"}');
     
     timeLbl := MyForm.AddNewProLabel(timeContainer,'timeLbl','--:--');
    clComponent.SetupComponent(timeLbl,'{"Align" : "Left","Width" :90,"TextColor":"#90646D","MarginLeft":15,
    "TextSize":26,"TextVerticalAlign":"center","TextHorizontalAlign":"left","TextBold":"yes"}');
    
    QRGen:= MyForm.AddNewQRCodeGenerator(mainPnl,'QRGen','Merhaba Dünya');
    QRGen.Height := 200;
    QRGen.Width := 200;
    QRGen.Align := alCenter;
    
    BtnNewQrCodeClick;
    GetTimer.Enabled  := True;
    MyForm.AddNewEvent(GetTimer,tbeOnTimer,'timerShow');
  end;
  procedure usersScrenn
  begin
    
    descriptionLbl := MyForm.AddNewProLabel(mainPnl,'descriptionLbl','QR Kod tarama için aşağıdaki butona basmalısınız. Ardından qr kodu taratın...');
    clComponent.SetupComponent(descriptionLbl,'{"Align" : "Top","MarginTop":50,"MarginLeft":20,"MarginRight":20,"Height":10,"TextColor":"#3B599C","TextSize":18,"TextVerticalAlign":"center",
    "TextHorizontalAlign":"center","AutoSize":"Vertical","BackgroundColor":"null"}');
    
    BtnReadQrCode := MyForm.AddNewProButton(mainPnl,'BtnReadQrCode','');
    clComponent.SetupComponent(BtnReadQrCode,'{"caption":"QRKod Oku...","Align" : "Center","Width" :200,"TextColor":"#3B599C","TextSize":25,
    "Height":70,"BackgroundColor":"#d1daf0","RoundHeight":15,"RoundWidth":15,"BorderColor":"#3B599C","BorderWidth":3}');
    MyForm.AddNewEvent(BtnReadQrCode,tbeOnClick,'BtnReadQrCodeClick');
    
    ReadQrEdt := MyForm.AddNewEdit(mainPnl,'ReadQrEdt','Barkod Okutunuz...');
    ReadQrEdt.Align := alBottom;
    ReadQrEdt.ReadOnly := True;
    ReadQrEdt.Visible := False;
  end;
begin
  if Clomosy.PlatformIsMobile then
      QrAppType := 2;//0:qrgenerator 1:Yonetici 2:Normal User
  
  if Not Clomosy.PlatformIsMobile then  //win üzeirinde açılı olan kullanıcı members listesini görsün
    QrAppType := 1;//0:qrgenerator 1:Yonetici 2:Normal User
  
  if Clomosy.AppUserProfile = 1 then
     QrAppType:=0;
     
  MyForm := TCLForm.Create(Self);
  MyForm.SetFormBGImage('https://clomosy.com/demos/bg4.jpg');
  GetTimer := MyForm.AddNewTimer(MyForm,'GetTimer',1000);
  
  mainPnl:=MyForm.AddNewProPanel(MyForm,'mainPnl');
  clComponent.SetupComponent(mainPnl,'{"Align" : "Client","BackgroundColor":"null"}');
    
  CaptionLbl := MyForm.AddNewProLabel(mainPnl,'CaptionLbl','QR PDKS UYGULAMASI');
  clComponent.SetupComponent(CaptionLbl,'{"Align" : "MostTop","MarginTop":30,
  "TextColor":"#3B599C","TextSize":30,"TextVerticalAlign":"center","TextHorizontalAlign":"center","TextBold":"yes","AutoSize":"Horizontal"}');
 
 
  if QrAppType = 0 then//QRGenerator ise
  begin
    adminScreen;
  end;
  
  if QrAppType = 1 then  //WINDOWS
  begin
    Clomosy.OpenForm(ftMembers,fdtsingle,froReadOnly, ffoNoFilter);
    Exit;
  end;
  
  if QrAppType = 2 then//QRReader ise Normal User
  begin
    usersScrenn;
  end;
  
  MyForm.Run;
end;