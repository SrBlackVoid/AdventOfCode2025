function GetButtonPressCombos {
	[CmdletBinding()]
	[OutputType([System.Array])]
	param(
		[int]$NumOfButtons,
		[int]$PressCount
	)

	$maxMask = (1 -shl $NumOfButtons) - 1

	foreach ($mask in 0..$maxMask) {
		if (([Convert]::ToString($mask,2).ToCharArray() |
			Where-Object { $_ -eq '1'
		}).Count -eq $PressCount) {
			$combo = @()

			for ($i = 0; $i -lt $NumOfButtons; $i++) {
				if ($mask -band (1 -shl $i)) {
					$combo += $i
				}
			}

			,$combo
		}
	}
}

function ConvertRowToVectors {
	[CmdletBinding()]
	[OutputType([hashtable])]
	param(
		$Data
	)

	$lights = [Regex]::Matches($Data,"\[(.+)\]").Groups[1].Value -replace "\.","0" -replace "#","1"
	Write-Debug "Raw light values: $($lights -replace "0","." -replace "1","#")"
	Write-Debug "Translated light value: $($result.Lights)"

	$buttons = [Regex]::Matches($Data,"\(([\d,]+)\)") | ForEach-Object {
		$_.Groups[1].Value
	}
	Write-Debug "Raw button values: $($buttons -join " | ")"

	$numOfLights = $lights.Length
	Write-Debug "Number of lights: $numOfLights"
	$buttonsConverted = foreach ($button in $buttons) {
		Write-Verbose "Converting ($button) to binary -> integer"
		$mask = 0
		foreach ($index in ($button -split ",")) {
			$bitPos = $numOfLights - 1 - [int]($index)
			$mask = $mask -bor (1 -shl $bitPos)
		}

		Write-Debug "Translated button binary value: $mask"
		$mask
	}

	$result = @{
		Lights = [Convert]::ToInt32($lights,2)
		LightCount = $numOfLights
		Buttons = $buttonsConverted
	}

	return $result
}

function SolveProblem1 {
<#
	STRATEGY: Converting lights and button configs to bitmasks, and brute-force running through possible button combos
	and BXOR application until matches are found.
	Avg. runtime: ~ 30-40 seconds
#>
	[CmdletBinding()]
	[OutputType([int])]
	param(
		[Parameter(Mandatory)]
		[string]$InputPath
	)

	$inputData = Get-Content $InputPath

	$answer = 0

	Write-Verbose "Processing input data"
	foreach ($line in $inputData) {
		Write-Verbose "Processing line: $line"
		$vectors = ConvertRowtoVectors -Data $line

		:RowProcessing for ($pressCount = 0; $pressCount -le $vectors.Buttons.Count; $pressCount++) {
			$combos = GetButtonPressCombos -NumOfButtons $vectors.Buttons.Count -PressCount $pressCount
			foreach ($combo in $combos) {
				Write-Verbose "Testing button combo: $($combo -join ", ")"
				$currentState = 0
				foreach ($buttonIndex in $combo) {
					$currentState = $currentState -bxor $vectors.Buttons[$buttonIndex]
					Write-Debug "Current state: $([Convert]::ToString($currentState,2).PadLeft($vectors.LightCount,'0'))"
				}

				if ($currentState -eq $vectors.Lights) {
					Write-Verbose "Found valid combination: $($combo -join ", ") resulting in all lights off"
					$answer += $pressCount
					break RowProcessing
				}
			}
		}
	}

	return $answer
}
