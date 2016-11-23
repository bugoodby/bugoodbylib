$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

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

public static class MyClass
{
	public static int lpr(string strIP, string strFile)
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
	
	public static int raw(string strIP, string strFile)
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
	
	public static int print(string printer, string strFile)
	{
		try
		{
			byte[] data = File.ReadAllBytes(strFile);
			
			LocalPrintServer localPrintServer = new LocalPrintServer();
			PrintQueue defaultPrintQueue = LocalPrintServer.GetDefaultPrintQueue();
			
			PrintSystemJobInfo newJob = defaultPrintQueue.AddJob();
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
}
'@

Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $source -Language CSharp
[System.Windows.Forms.Application]::EnableVisualStyles()

$prtSrv = New-Object System.Printing.LocalPrintServer
$SetPortName = {
	$prtQue = $prtSrv.GetPrintQueues() | ?{ $_.Name -eq $combo.Text }
	$label2.Text = ($prtQue.QueuePort.Name)
}

$form = New-Object System.Windows.Forms.Form 
$form.Text = "test"
$form.Size = New-Object System.Drawing.Size(500,350)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(230,20)
$label.Text = "List"

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

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,($combo.Bottom+10))
$label2.Size = New-Object System.Drawing.Size(450,20)
$label2.Text = ""

$listView = New-Object System.Windows.Forms.ListView
$listView.Location = New-Object System.Drawing.Point(10,($label2.Bottom+10))
$listView.Size = New-Object System.Drawing.Size(450,160)
$listView.View = "Details"
$listView.GridLines = $true
$listView.FullRowSelect = $true
$listView.MultiSelect = $true
[void]$listView.Columns.Add("Name", 100)
[void]$listView.Columns.Add("Path", 500)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,($listView.Bottom+10))
$button.Size = New-Object System.Drawing.Size(75,30)
$button.Text = "OK"
$button.Add_Click({
	foreach ( $item in $listView.Items ) {
		if ( $item.Selected ) {
			[MyClass]::print($combo.Text, $item.SubItems[0].Text)
		}
	}
})

$form.Controls.Add($label)
$form.Controls.Add($combo)
$form.Controls.Add($label2)
$form.Controls.Add($listView)
$form.Controls.Add($button)

$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	foreach ( $path in $_.Data.GetData("FileDrop") ) {
		$item = New-Object System.Windows.Forms.ListViewItem([System.IO.Path]::GetFileName($path))
		[void]$item.SubItems.Add($path)
		[void]$listView.Items.Add($item)
	}
})

& $SetPortName
$form.ShowDialog()

