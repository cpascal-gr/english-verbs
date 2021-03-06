import 'package:angular2/angular2.dart' show Component, NgFor, NgClass, NgIf;
import 'package:angular2/router.dart' show RouteParams, Router;
import 'package:english_verbs/app.services.dart'
    show ConjugationService, Conjugation, Tense, Person, Plurality, Time;
import 'package:usage/usage.dart' show Analytics;
import 'package:ng_mediaquery/ng_mediaquery.dart';

@Component(
    selector: 'conjugation_view',
    templateUrl: 'conjugation_view.html',
    styleUrls: const ['conjugation_view.css'],
    directives: const [NgFor, NgClass, NgIf, MediaQuery],
    providers: const [ConjugationService])
class ConjugationView {
  RouteParams _params;
  Router _router;
  ConjugationService _conjugator;
  List _data;
  String infinitive;
  Tense _tense;
  Conjugation _conjugation;
  Analytics _analytics;

  List tenses = [
    {'value': 'Simple', 'enum': Tense.Simple},
    {'value': 'Progressive', 'enum': Tense.Progressive},
    {'value': 'Perfect', 'enum': Tense.Perfect},
    {'value': 'Perfect-Progressive', 'enum': Tense.PerfectProgressive},
  ];

  get data => _data;

  Tense get tense => this._tense;

  set tense(Tense tense) {
    this._tense = tense;
    this._data = _conjugation.getConjugationTable(tense);
    this._analytics.sendEvent('Tense', 'change',
        label: tense.toString(), value: 1);
  }

  ConjugationView(
      this._params, this._router, this._conjugator, this._analytics) {
    if (_params.get('verb') == null) _router.navigate([
      'ConjugationView',
      {'verb': 'be'}
    ]);
    else _boot();

    _analytics.sendScreenView("Conjugation");
  }

  _boot() {
    String search = _params.get('verb').replaceAll('%20',' ');
    try {
      _conjugation = _conjugator.find(search);
      this.infinitive = _conjugation.infinitive;
      tense = Tense.Simple;
      this._analytics.sendEvent('Page', 'vizualization',
          label: search, value: 1);
    } catch (e) {
      _router.navigate([
        'VerbNotFoundView',
        {'search': search}
      ]);
    }
  }
}
