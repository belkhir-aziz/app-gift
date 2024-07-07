import 'package:flutter/material.dart';
import 'package:namer_app/models/gift.dart';
import 'package:namer_app/services/gift_provider.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

class GiftPage extends StatefulWidget {
  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  final GiftProvider giftProvider = GiftProvider();

  @override
  void initState() {
    super.initState();
    // Initialize gifts when the widget is created
    giftProvider.initializeGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swiping Card Deck Example'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          // Wait for the completion of initializeGifts
          future: giftProvider.initializeGifts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Gift> cards = giftProvider.gifts;
              var cardHeight = MediaQuery.of(context).size.height * 0.7;
              final SwipingCardDeck deck = SwipingCardDeck(
                cardDeck: createCards(cards, cardHeight),
                onDeckEmpty: () => debugPrint("Card deck empty"),
                onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
                onRightSwipe: (Card card) => debugPrint("Swiped right!"),
                cardWidth: 200,
                swipeAnimationDuration: Duration(milliseconds: 20),
                rotationFactor: 0.8 / 3.14,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: cardHeight,
                    child: deck,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Color.lerp(Colors.red, Colors.green, 0.1),
                          radius: 25,
                          child: IconButton(
                            icon: Icon(Icons.clear, color: Colors.white),
                            onPressed: deck.animationActive
                                ? null
                                : () => deck.swipeLeft(),
                          ),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor:
                              Color.lerp(Colors.red, Colors.green, 0.3),
                          radius: 25,
                          child: IconButton(
                            icon: Icon(Icons.star, color: Colors.white),
                            onPressed: () => debugPrint("Superlike pressed"),
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor:
                              Color.lerp(Colors.red, Colors.green, 0.6),
                          radius: 25,
                          child: IconButton(
                            icon:
                                Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: () => debugPrint("Purchase pressed"),
                          ),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor:
                              Color.lerp(Colors.red, Colors.green, 0.9),
                          radius: 25,
                          child: IconButton(
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: deck.animationActive
                                ? null
                                : () => deck.swipeRight(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              // You can return a loading indicator or some other widget while waiting
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  List<Card> createCards(List<Gift> cards, double cardHeight) {
    List<Card> cardDeck = [];
    for (Gift card in cards) {
      cardDeck.add(
        Card(
          child: Column(
            children: [
              SizedBox(
                height: cardHeight * 0.1,
                child: ListTile(
                  title: Text('Recommend gifts for Aziz'),
                ),
              ),
              SizedBox(
                height: cardHeight * 0.7,
                child: Image.network(
                  card.uri,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: cardHeight * 0.1,
                child: ListTile(
                  title: Text(card.name),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return cardDeck;
  }
}
