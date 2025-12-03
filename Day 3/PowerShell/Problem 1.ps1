function GetJoltage {
	[CmdletBinding()]
	param(
		[string]$BatteryBank
	)

	Write-Verbose "Selecting left battery"

	$leftBatteryValue = $BatteryBank.ToCharArray() |
		Select-Object -SkipLast 1 -Unique |
		Sort-Object -Descending |
		Select-Object -First 1
	Write-Debug "Left battery value: $leftBatteryValue"

	$leftBatteryIndex = $BatteryBank.IndexOf($leftBatteryValue)

	$rightBatteryValue = ($BatteryBank.Substring($leftBatteryIndex + 1)).ToCharArray() |
		Select-Object -Unique |
		Sort-Object -Descending |
		Select-Object -First 1
	Write-Debug "Right battery value: $rightBatteryValue"

	$joltage = "$leftBatteryValue$rightBatteryValue" -as [int]
	Write-Debug "Joltage: $joltage"

	return $joltage
}

function SolveProblem1 {
	[CmdletBinding()]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath

	$answer = 0

	foreach ($line in $inputData) {
		Write-Verbose "Processing bank $line"
		$answer += GetJoltage -BatteryBank $line
	}

	return $answer
}
