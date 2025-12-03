function GetJoltage {
	[CmdletBinding()]
	[OutputType([int64])]
	param(
		[string]$BatteryBank
	)

	$turnOnList = [string[]]::new(12)
	$index = 0
	$remainingBank = $BatteryBank.Clone()

	foreach ($index in 0..11) {
		Write-Verbose "Getting battery $($index+1)"
		$batteryValue = $remainingBank.ToCharArray() |
			Select-Object -SkipLast (11 - $index) -Unique |
			Sort-Object -Descending |
			Select-Object -First 1
		Write-Debug "Battery $($index+1): $batteryValue"
		$turnOnList[$index] = $batteryValue

		$batteryIndex = $remainingBank.IndexOf($batteryValue)
		$remainingBank = $remainingBank.SubString($batteryIndex + 1)
	}

	$joltage = $turnOnList -join "" -as [int64]
	Write-Debug "Joltage: $joltage"

	return $joltage
}

function SolveProblem2 {
	[CmdletBinding()]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath

	[int64]$answer = 0

	foreach ($line in $inputData) {
		Write-Verbose "Processing bank $line"
		$answer += GetJoltage -BatteryBank $line
	}

	return $answer
}
