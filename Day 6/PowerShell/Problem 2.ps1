function ReworkNumbers {
	[CmdletBinding()]
	[OutputType([int[]])]
	param([string[]]$Numbers,$MaxLength)

	Write-Verbose "Starting $($MyInvocation.MyCommand)"
	$newNumbers = @()
	foreach ($digit in $maxLength..1) {
		Write-Verbose "Getting digit #$digit from numbers"
		$newNumberDigits = $Numbers | ForEach-Object {
			$_[$digit - 1]
		} | Where-Object { [int]::TryParse($_,[ref]$null)}
		Write-Debug "New number digits: $($newNumberDigits -join ", ")"
		$newNumber = $newNumberDigits -join "" -as [int]
		Write-Debug "New number: $newNumber"

		$newNumbers += $newNumber
	}

	return $newNumbers
}

function SolveColumnProblem {
	[CmdletBinding()]
	param($Numbers,$Operator)

	$mathProblem = $Numbers -join " $Operator "
	Write-Verbose "Executing: $mathProblem"
	$scriptblock = [ScriptBlock]::Create($mathProblem)
	$answer = & $scriptBlock
	Write-Debug "$mathProblem = $answer"

	return $answer
}

function SolveProblem2 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath
	$workableData = $inputData -split "`n"

	$operandLine = $workableData[-1]
	$operandIndexes = [Regex]::Matches($operandLine,"[\*\+]")
	#Operators are always under left-most digit in column
	$numberRowCount = $workableData.Count - 1

	$answer = [int64[]]::New($operandIndexes.count)

	foreach ($columnNum in 0..($operandIndexes.Count-1)) {
		Write-Verbose "Processing Column $($columnNum + 1)"
		$currentOperand = $operandIndexes[$columnNum].Value
		$currentOperandIndex = $operandIndexes[$columnNum].Index
		$maxLength = ($operandIndexes[$columnNum + 1].Index ?? $operandLine.Length) - $currentOperandIndex
		if ($columnNum -ne $($operandIndexes.Count - 1)) {
			$maxLength--
		}
		Write-Debug ([ordered]@{
			ColumnNum = $($columnNum + 1)
			Operand = $currentOperand
			OperandIndex = $currentOperandIndex
			MaxDigitLength = $maxLength
		} | Out-String)

		$column = $workableData[0..($numberRowCount - 1)] | ForEach-Object {
			$_.Substring($operandIndexes[$columnNum].Index,$maxLength)
		}
		Write-Debug "Column:`n$($column -split "`n" | Out-String)"

		$newNumbers = ReworkNumbers -Numbers $column -MaxLength $maxLength

		$answer[$columnNum] = SolveColumnProblem -Numbers $newNumbers -Operator $currentOperand
	}

	return ($answer | Measure-Object -Sum).Sum
}
