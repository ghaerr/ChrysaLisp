$HCPU = "x86_64"
$HABI = "WIN64"
$HOS  = "Windows"

function zero_pad {

    param (
        $c
    )

    if ( $c -lt 100 ){
    	$zp = "0$c"
    }
    else {
    	$zp = $c
    }

    if ( $c -lt 10 ){
    	$zp = "0$zp"
    }

    $zp
}

function add_link
{
	param (
		$src,
		$dst,
		$links
	)
	if ( $src -ne $dst ){
		if ( $src -lt $dst ){
			$nl="$src-$dst"
		}
		else {
			$nl="$dst-$src"
		}

		if ( $links.IndexOf($nl) -eq -1 ){
			$rv = "-l $nl "
		}
		else {
			$rv = ""
		}
	}

	$rv
}

function boot_cpu_gui
{
	param (
		$cpu,
		$lnk
	)
	if ( $cpu -lt 1 ){
		Start-Process -FilePath ./obj/$HCPU/$HABI/$HOS/main -NoNewWindow -ArgumentList "obj/$HCPU/$HABI/sys/boot_image -cpu $cpu $link -run gui/gui/gui.lisp"
	}
	else {
		Start-Process -FilePath ./obj/$HCPU/$HABI/$HOS/main -NoNewWindow -ArgumentList "obj/$HCPU/$HABI/sys/boot_image -cpu $cpu $link"
	}
}

function boot_cpu_tui
{
	param (
		$cpu,
		$lnk
	)
	if ( $cpu -lt 1 ){
		Start-Process -FilePath ./obj/$HCPU/$HABI/$HOS/main -NoNewWindow -ArgumentList "obj/$HCPU/$HABI/sys/boot_image -cpu $cpu $link -run apps/terminal/tui.lisp"
	}
	else {
		Start-Process -FilePath ./obj/$HCPU/$HABI/$HOS/main -NoNewWindow -ArgumentList "obj/$HCPU/$HABI/sys/boot_image -cpu $cpu $link"
	}
}
