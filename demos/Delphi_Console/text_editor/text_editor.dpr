program text_editor;

{$I ..\..\..\source\uWebUI.inc}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils, System.Classes,
  {$ELSE}
  SysUtils, Classes,
  {$ENDIF}
  uWebUI, uWebUIWindow, uWebUITypes, uWebUIEventHandler, uWebUILibFunctions,
  uWebUIConstants, uWebUIMiscFunctions;

var
  LWindow : IWebUIWindow;

procedure close_app(e: PWebUIEvent); cdecl;
begin
	writeln('Exit.');

	// Close all opened windows
	WebUI.Exit;
end;

begin
  try
    WebUI := TWebUI.Create;
    {$IFDEF DEBUG}
    //WebUI.LoaderDllPath := WEBUI_DEBUG_LIB;
    {$ENDIF}
    if WebUI.Initialize then
      begin
        LWindow := TWebUIWindow.Create;

        // Set the web-server root folder for the first window
        {$IFDEF MSWINDOWS}
        LWindow.SetRootFolder(CustomAbsolutePath('..\assets\text_editor\', True));
        {$ELSE}
        LWindow.SetRootFolder(CustomAbsolutePath('../assets/text_editor/', True));
        {$ENDIF}

        // Bind HTML elements with the specified ID to C functions
        LWindow.Bind('close_app', close_app);

        // Show the window, preferably in a chromium based browser
        if not(LWindow.ShowBrowser('index.html', ChromiumBased)) then
          LWindow.Show('index.html');

        WebUI.Wait;
      end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
