#include <stdio.h>

// Functia principala de pornire a ecranului pentru ABINSTEIN OS
void aprinde_ecranul_fizic() {
    printf("[ABINSTEIN OS] Se trimite curent catre ecran...\n");
    printf("[ABINSTEIN OS] Lumina de fundal este PORNESTE (Status: 100%%)\n");
    printf("[ABINSTEIN OS] Ecran aprins cu succes! Se incarca ceasul si butoanele...\n");
}

int main() {
    aprinde_ecranul_fizic();
    return 0;
}
