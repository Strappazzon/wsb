@{
  ExcludeRules = @(
    # Can't be replaced
    'PSAvoidUsingInvokeExpression',
    # Write-Host supports colors
    'PSAvoidUsingWriteHost',
    'PSUseDeclaredVarsMoreThanAssignments',
    # I don't care about ShouldProcess, it's a sandbox
    'PSUseShouldProcessForStateChangingFunctions'
  )
  Rules        = @{
    PSAvoidUsingPositionalParameters = @{
      CommandAllowList = @('scoop')
    }
  }
}
