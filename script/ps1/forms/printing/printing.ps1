$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

$assemblies = (
 "System.Windows.Forms",
 "System.Drawing",
 "System.Printing"
)

$source = @'
using System;
using System.IO;
using System.Windows.Forms;
using System.Diagnostics;
using System.Printing;
using System.Runtime.InteropServices;

public static class PrintUtil
{
	[DllImport("shell32.dll")]
	static extern int SHInvokePrinterCommand(IntPtr hwnd, uint uAction, string lpBuf1, string lpBuf2, int fModal);
	const uint PRINTACTION_OPEN = 0;
	const uint PRINTACTION_PROPERTIES = 1;

	public static int InvokeLPR(string strIP, string strFile)
	{
		ProcessStartInfo startInfo = new ProcessStartInfo();
		startInfo.FileName = Environment.GetEnvironmentVariable("ComSpec");
		startInfo.CreateNoWindow = true;
		startInfo.UseShellExecute = false;
		startInfo.RedirectStandardOutput = true;
		startInfo.Arguments = String.Format(@"/c ""lpr -S {0} -P lp ""{1}""""", strIP, strFile);
		
		Process process = Process.Start(startInfo);
		process.WaitForExit();
		
		string str = startInfo.FileName + " " + startInfo.Arguments + "\n";
		str += process.StandardOutput.ReadToEnd();
		MessageBox.Show(str);
		
		return process.ExitCode;
	}
	
	public static int SendRaw(string strIP, string strFile)
	{
		try
		{
			byte[] data = File.ReadAllBytes(strFile);
			
			System.Net.Sockets.TcpClient tcpClient = new System.Net.Sockets.TcpClient();
			tcpClient.Connect(strIP, 9100);
			System.Net.Sockets.NetworkStream stream = tcpClient.GetStream();
			stream.Write(data, 0, data.Length);
			stream.Close();
			tcpClient.Close();
		}
		catch (Exception e)
		{
			MessageBox.Show(e.ToString());
			return -1;
		}
		
		return 0;
	}
	
	public static int SubmitToSpooler(string strPrinter, string strFile)
	{
		try
		{
			byte[] data = File.ReadAllBytes(strFile);
			
			LocalPrintServer localPrintServer = new LocalPrintServer();
			PrintQueue pq = localPrintServer.GetPrintQueue(strPrinter);
			
			PrintSystemJobInfo newJob = pq.AddJob();
			Stream stream = newJob.JobStream;
			stream.Write(data, 0, data.Length);
			stream.Close();
		}
		catch (Exception e)
		{
			MessageBox.Show(e.ToString());
			return -1;
		}
		
		return 0;
	}
	
	public static string GetDefaultPrinter()
	{
		System.Drawing.Printing.PrintDocument pd = new System.Drawing.Printing.PrintDocument();
		string defaultPrinter = pd.PrinterSettings.PrinterName;
		return defaultPrinter;
	}
	
	public static void OpenSpooler( string prnName )
	{
		IntPtr hwnd = Process.GetCurrentProcess().MainWindowHandle;
		SHInvokePrinterCommand(hwnd, PRINTACTION_OPEN, prnName, null, 1);
	}
	
	public static void OpenProperties( string prnName )
	{
		IntPtr hwnd = Process.GetCurrentProcess().MainWindowHandle;
		SHInvokePrinterCommand(hwnd, PRINTACTION_PROPERTIES, prnName, null, 1);
	}
}
'@

Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $source -Language CSharp
[System.Windows.Forms.Application]::EnableVisualStyles()

function EditForm_Show( [ref]$times, [ref]$interval )
{
	Write-Host $times.Value
	
	$form = New-Object System.Windows.Forms.Form 
	$form.Text = "Settings"
	$form.Size = New-Object System.Drawing.Size(260,150)
	$form.StartPosition = "CenterParent"
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
	$form.Font = New-Object System.Drawing.Font("", 9)

	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,10)
	$label.Size = New-Object System.Drawing.Size(60,20)
	$label.Text = "Times: "

	$numBoxTimes = New-Object System.Windows.Forms.NumericUpDown
	$numBoxTimes.Location = New-Object System.Drawing.Point(($label.Right+10), ($label.Top))
	$numBoxTimes.Size = New-Object System.Drawing.Size(100, 20)
	$numBoxTimes.Maximum = 9999
	$numBoxTimes.Minimum = 1
	$numBoxTimes.Text = $times.Value
	
	$label2 = New-Object System.Windows.Forms.Label
	$label2.Location = New-Object System.Drawing.Point(10,($label.Bottom+20))
	$label2.Size = New-Object System.Drawing.Size(60,20)
	$label2.Text = "Interval: "

	$numBoxInterval = New-Object System.Windows.Forms.NumericUpDown
	$numBoxInterval.Location = New-Object System.Drawing.Point(($label2.Right+10), ($label2.Top))
	$numBoxInterval.Size = New-Object System.Drawing.Size(100, 20)
	$numBoxInterval.Maximum = 9999
	$numBoxInterval.Minimum = 0
	$numBoxInterval.Text = $interval.Value
	
	$button = New-Object System.Windows.Forms.Button
	$button.Location = New-Object System.Drawing.Point(10,($label2.Bottom+10))
	$button.Size = New-Object System.Drawing.Size(75,30)
	$button.Text = "OK"
	$button.Add_Click({
		$times.Value = $numBoxTimes.Text
		$interval.Value = $numBoxInterval.Text
		$form.Close()
	})

	$form.Controls.AddRange(@($label,$numBoxTimes,$label2,$numBoxInterval,$button))

	[void]$form.ShowDialog()
}

function MainForm_Show()
{
	$prtSrv = New-Object System.Printing.LocalPrintServer
	$SetPortName = {
		$prtQue = $prtSrv.GetPrintQueues() | ?{ $_.Name -eq $combo.Text }
		$lblPort.Text = "port: $($prtQue.QueuePort.Name)"
	}

	$form = New-Object System.Windows.Forms.Form 
	$form.Text = "test"
	$form.Size = New-Object System.Drawing.Size(500,350)
	$form.StartPosition = "WindowsDefaultLocation"
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
	$form.Font = New-Object System.Drawing.Font("", 9)

	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,10)
	$label.Size = New-Object System.Drawing.Size(230,20)
	$label.Text = "Printer:"

	$combo = New-Object System.Windows.Forms.Combobox
	$combo.Location = New-Object System.Drawing.Point(10,30)
	$combo.size = New-Object System.Drawing.Size(250,30)
	$combo.DropDownStyle = "DropDownList"
	& {
		$pd = New-Object System.Drawing.Printing.PrintDocument
		$prtSrv.GetPrintQueues() | % {
			$index = $combo.Items.Add($_.Name)
			if ( $_.Name -eq $pd.PrinterSettings.PrinterName ) {
				$combo.SelectedIndex = $index
			}
		}
	}
	$combo.Add_SelectedIndexChanged($SetPortName)

	$lblPort = New-Object System.Windows.Forms.Label
	$lblPort.Location = New-Object System.Drawing.Point(10,($combo.Bottom+10))
	$lblPort.Size = New-Object System.Drawing.Size(450,20)
	$lblPort.Text = ""

	$btnSpool = New-Object System.Windows.Forms.Button
	$btnSpool.Location = New-Object System.Drawing.Point(($combo.Right+10),($combo.Top))
	$btnSpool.Size = New-Object System.Drawing.Size(75,25)
	$btnSpool.Text = "spooler"
	$btnSpool.Add_Click({
		[PrintUtil]::OpenSpooler($combo.Text)
	})
	$btnProp = New-Object System.Windows.Forms.Button
	$btnProp.Location = New-Object System.Drawing.Point(($btnSpool.Right+10),($btnSpool.Top))
	$btnProp.Size = New-Object System.Drawing.Size(75,25)
	$btnProp.Text = "properties"
	$btnProp.Add_Click({
		[PrintUtil]::OpenProperties($combo.Text)
	})

	$listView = New-Object System.Windows.Forms.ListView
	$listView.Location = New-Object System.Drawing.Point(10,($lblPort.Bottom+10))
	$listView.Size = New-Object System.Drawing.Size(450,160)
	$listView.View = "Details"
	$listView.GridLines = $true
	$listView.FullRowSelect = $true
	$listView.MultiSelect = $false
	$listView.HideSelection = $false
	[void]$listView.Columns.Add("Name", 300)
	[void]$listView.Columns.Add("times", 50)
	[void]$listView.Columns.Add("interval[ms]", 50)
	[void]$listView.Columns.Add("Path", 500)

	$contextMenu = New-object System.Windows.Forms.ContextMenuStrip
	$listView.ContextMenuStrip = $contextMenu
	$contextMenu1 = New-Object System.Windows.Forms.ToolStripMenuItem
	$contextMenu1.Text = "Settings"
	$contextMenu2 = New-Object System.Windows.Forms.ToolStripMenuItem
	$contextMenu2.Text = "Remove"
	[void]$contextMenu.Items.Add($contextMenu1)
	[void]$contextMenu.Items.Add($contextMenu2)
	$contextMenu.Add_ItemClicked({
		switch($_.ClickedItem.Text) {
		"Settings" {
				$item = $listView.SelectedItems[0]
				$times = $item.SubItems[1].Text
				$interval = $item.SubItems[2].Text
				EditForm_Show ([ref]$times) ([ref]$interval)
				$item.SubItems[1].Text = $times
				$item.SubItems[2].Text = $interval
			}
		"Remove" { $listView.SelectedItems | %{ $listView.Items.Remove($_) } }
		default { }
		}
	})
	$contextMenu.Add_Opening({
		if ($listView.SelectedItems.Count -le 0) { $_.Cancel = $true; }
	})

	$btnPrint = New-Object System.Windows.Forms.Button
	$btnPrint.Location = New-Object System.Drawing.Point(10,($listView.Bottom+10))
	$btnPrint.Size = New-Object System.Drawing.Size(75,30)
	$btnPrint.Text = "Print"
	$btnPrint.Add_Click({
		foreach ( $item in $listView.SelectedItems ) {
			$times = [uint32]$item.SubItems[1].Text
			$interval = [uint32]$item.SubItems[2].Text
			for ( $i = 0; $i -lt $times; $i++ ) {
				[PrintUtil]::SubmitToSpooler($combo.Text, $item.SubItems[3].Text)
				if ( $interval -gt 0 ) {
					Start-Sleep -m $interval
				}
			}
		}
	})
	
	$btnClear = New-Object System.Windows.Forms.Button
	$btnClear.Location = New-Object System.Drawing.Point(($btnPrint.Right+20),($btnPrint.Top))
	$btnClear.Size = New-Object System.Drawing.Size(75,30)
	$btnClear.Text = "Clear"
	$btnClear.Add_Click({
		$listView.Items.Clear()
	})
	
	$form.Controls.AddRange(@($label,$combo,$btnSpool,$btnProp,$lblPort,$listView,$btnPrint,$btnClear))

	$asTop = [System.Windows.Forms.AnchorStyles]::Top
	$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
	$asLeft = [System.Windows.Forms.AnchorStyles]::Left
	$asRight = [System.Windows.Forms.AnchorStyles]::Right
	$listView.Anchor = $asTop -bor $asBottom -bor $asLeft -bor $asRight
	$btnPrint.Anchor = $asBottom -bor $asLeft
	$btnClear.Anchor = $asBottom -bor $asLeft
	
	
	$form.AllowDrop = $true
	$form.Add_DragEnter({$_.Effect = 'Copy'})
	$form.Add_DragDrop({
		foreach ( $path in $_.Data.GetData("FileDrop") ) {
			$item = New-Object System.Windows.Forms.ListViewItem([System.IO.Path]::GetFileName($path))
			[void]$item.SubItems.Add(1)
			[void]$item.SubItems.Add(0)
			[void]$item.SubItems.Add($path)
			[void]$listView.Items.Add($item)
		}
	})

	& $SetPortName
	[void]$form.ShowDialog()
}

MainForm_Show

