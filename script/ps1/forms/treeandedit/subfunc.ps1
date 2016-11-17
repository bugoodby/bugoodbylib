function Refresh-TreeView( $path )
{
	$treeView.Nodes.Clear()
	
	$lv1Nodes = $treeView.Nodes
	$lv2Nodes = $null
	$lv3Nodes = $null
	
	Import-Csv $path | %{
		$info = $_
		switch ($info.Type) {
		1 { $n = $lv1Nodes.Add($info.Text); $n.Tag = $info.Tag; $lv2Nodes = $n.Nodes; }
		2 { $n = $lv2Nodes.Add($info.Text); $n.Tag = $info.Tag; $lv3Nodes = $n.Nodes; }
		3 { $n = $lv3Nodes.Add($info.Text); $n.Tag = $info.Tag; }
		default {}
		}
	}
}
