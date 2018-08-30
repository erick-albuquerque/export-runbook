#add-AzureRmAccount

#Faz o GET de todas as subscriptions
$subscriptionName = Get-AzureRmSubscription | Select -ExpandProperty Name -First 100

#Define onde vai salvar os runbooks
$path = "c:\Backup" #Pode editar o caminho para o local desejado

#Teste se existe o diretorio do $path, se não existir cria.
if (Test-Path $path){
    
        New-Item -ItemType directory -Path "$path\$((Get-Date).ToString('yyyy-MM-dd'))"

} else { 
        New-Item -ItemType directory -Path $path
        New-Item -ItemType directory -Path "$path\$((Get-Date).ToString('yyyy-MM-dd'))"
       }

foreach( $SubsName in $subscriptionName){

        Select-AzureRmSubscription -Subscription $SubsName
        
        $AutomationAccount = Get-AzureRmAutomationAccount
        $AccAutomation_all = $AutomationAccount.AutomationAccountName
        $RGName_all = $AutomationAccount.ResourceGroupName
    

        foreach($AccAutomation in $AccAutomation_all){
    
            foreach($RGName in $RGName_all){
    
                if(![string]::IsNullOrEmpty($AccAutomation)){
            
                        $RunBookName = Get-AzureRmAutomationRunbook -AutomationAccountName "$AccAutomation" -ResourceGroupName "$RGName" | Select -ExpandProperty Name -First 100 -ErrorAction Continue

                        foreach( $RBname in $RunBookName){
        
                        Export-AzureRmAutomationRunbook -name $RBname -AutomationAccountName "$AccAutomation" -ResourceGroupName "$RGName" -Force -OutputFolder "$path\$((Get-Date).ToString('yyyy-MM-dd'))"
                        }        
                }
            }
    
       }
}


