Describe "GetJoltage" {
	BeforeAll {
		. ".\Problem 1.ps1"
	}

	Context "Demo examples" {
		It "Returns 98 when fed in 987654321111111" {
			$testInput = "987654321111111"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 98
		}

		It "Returns 89 when fed in 811111111111119" {
			$testInput = "811111111111119"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 89
		}

		It "Returns 78 when fed in 234234234234278" {
			$testInput = "234234234234278"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 78
		}

		It "Returns 92 when fed in 818181911112111" {
			$testInput = "818181911112111"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 92
		}
	}
}

Describe "SolveProblem1" {
	BeforeAll {
		$source = ".\Problem 1.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem1 -InputPath $inputPath

		$result | Should -Be 357
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
