Describe "TurnDial" {
	BeforeAll {
		. ".\Problem 1.ps1"
	}

	It "Should throw if not given a valid left-right direction" {
		$testCurrent = 50
		$testDirections = "X120"

		{ TurnDial $testCurrent $testDirections } |
			Should -Throw -ExpectedMessage "Invalid direction format"
	}

	It "Should throw if not given any number after the direction" {
		$testCurrent = 50
		$testDirections = "L"

		{ TurnDial $testCurrent $testDirections } |
			Should -Throw -ExpectedMessage "Invalid direction format"
	}

	It "Should go down in numbers when turning left" {
		$testCurrent = 50
		$testDirections = "L5"

		$results = TurnDial $testCurrent $testDirections

		$results | Should -Be 45
	}

	It "Should go up in numbers when turning right" {
		$testCurrent = 50
		$testDirections = "R5"

		$results = TurnDial $testCurrent $testDirections

		$results | Should -Be 55
	}

	It "Should wrap around to 99 if turned past 0 going left" {
		$testCurrent = 10
		$testDirections = "L20"

		$results = TurnDial $testCurrent $testDirections

		$results | Should -Be 90
	}

	It "Should wrap around to 0 if turned past 99 going right" {
		$testCurrent = 90
		$testDirections = "R20"

		$results = TurnDial $testCurrent $testDirections

		$results | Should -Be 10
	}
}

Describe "SolveProblem1" {
	BeforeAll {
		$source = ".\Problem 1.ps1"

		. $source
	}

	It "Returns 3 for the demo example" {
		$inputPath = ".\Problem 1 demo inputs.txt"

		$result = SolveProblem1 -InputPath $inputPath

		$result | Should -Be 3
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
