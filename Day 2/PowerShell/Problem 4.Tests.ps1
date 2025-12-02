Describe "GetInvalidIDs" {
	BeforeAll {
		.  ".\Problem 4.ps1"
	}

	Context "Demo examples" {
		It "Returns (11,22) when fed in 11-22" {
			$startIndex = 11
			$endIndex = 22

			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex

			$result | Should -BeExactly @(11,22)
		}

		It "Returns (99,111) when fed in 95-115" {
			$startIndex = 95
			$endIndex = 115

			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex

			$result | Should -BeExactly @(99,111)
		}

		It "Returns (999,1010) when fed in 998-1012" {
			$startIndex = 998
			$endIndex = 1012
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -BeExactly @(999,1010)
		}

		It "Returns (1188511885) when fed in 1188511880-1188511890" {
			$startIndex = 1188511880
			$endIndex = 1188511890
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 1188511885
		}

		It "Returns (222222) when fed in 222220-222224" {
			$startIndex = 222220
			$endIndex = 222224
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 222222
		}

		It "Doesn't return anything when fed in 1698522-1698528" {
			$startIndex = 1698522
			$endIndex = 1698528
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -BeNullOrEmpty
		}

		It "Returns (446446) when fed in 446443-446449" {
			$startIndex = 446443
			$endIndex = 446449
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 446446
		}

		It "Returns (565656) when fed in 565653-565659" {
			$startIndex = 565653
			$endIndex = 565659
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 565656
		}

		It "Returns (38593859) when fed in 38593856-38593862" {
			$startIndex = 38593856
			$endIndex = 38593862
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 38593859
		}

		It "Returns (2121212121) when fed in 2121212118-2121212124" {
			$startIndex = 2121212118
			$endIndex = 2121212124
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 2121212121
		}
	}

}

Describe "SolveProblem4" {
	BeforeAll {
		$source = ".\Problem 4.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem4 -InputPath $inputPath

		$result | Should -Be 4174379265
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
