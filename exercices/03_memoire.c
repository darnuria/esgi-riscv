#include <stdint.h>
// On demande au compilateur de *pas optimiser* les
// acces mémoires avec `volatile`.
// En embarqué ou kernel c'est parfois indispensable.
// Le reste du temps c'est contre-productif. ;)
// `static` indique la variable est locale au fichier.
static volatile int32_t num0 = 124;
static volatile int32_t num1 = 256;
static volatile int32_t result_g = 0;

void main(void) {
  // Notez que votre langage cache ici l'usage de pointeurs,
  // en réalité on manipule de la mémoire ici.
  // surtout si aucune optimisation a lieu.
  result_g = num0 + num1;
  printf("%d", result_g);
}