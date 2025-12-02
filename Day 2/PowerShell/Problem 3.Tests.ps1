Describe "GetInvalidIDs" {
	BeforeAll {
		.  ".\Problem 3.ps1"
	}

	Context "Demo examples" {
		It "Returns (11,22) when fed in 11-22" {
			$startIndex = 11
			$endIndex = 22

			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex

			$result | Should -BeExactly @(11,22)
		}

		It "Returns (99) when fed in 95-115" {
			$startIndex = 95
			$endIndex = 115

			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex

			$result | Should -Be 99
		}

		It "Returns (1010) when fed in 998-1012" {
			$startIndex = 998
			$endIndex = 1012
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 1010
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

		It "Returns (38593859) when fed in 38593856-38593862" {
			$startIndex = 38593856
			$endIndex = 38593862
			$result = GetInvalidIDs -StartIndex $startIndex -EndIndex $endIndex
			$result | Should -Be 38593859
		}
	}

}

Describe "SolveProblem3" {
	BeforeAll {
		$source = ".\Problem 3.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem3 -InputPath $inputPath

		$result | Should -Be 1227775554
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
