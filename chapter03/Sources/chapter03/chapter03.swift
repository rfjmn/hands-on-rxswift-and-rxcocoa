import RxSwift
import RxCocoa

@main
public struct Chapter03 {
    public static func main() {
        /*
         Traitsは、ストリームが満たす契約を型で表す。
         - Single: 値を1つ返すか、エラーで終了する。
         - Maybe: 値を1つ返す、値なしで完了する、エラーで終了する、のいずれか。
         - Completable: 値を返さず、完了またはエラーだけを通知する。HTTPメソッドとの固定の対応はない。
         これらの型だけでは購読の共有や過去の値の再送は保証されない。
         asSingle／asMaybeへの変換では、元のObservableの要素数が契約を満たす必要がある。
         Observableの要素を無視して完了だけを扱う場合はignoreElementsを使う。

         RxCocoaのUI用Traits:
         - Driver: エラーを流さず、メインスレッドへ配送する。接続中の購読者で最新の1件を共有する。
         - Signal: エラーを流さず、メインスレッドへ配送する。新しい購読者へ過去の値を再送しない。
         - ControlProperty: textField.rx.textなど、UI要素の値を読み書きする境界。
         - ControlEvent: button.rx.tapなど、UI操作のイベントを表す。初期値を送らない。
         Driverのdriveなど、UIへのバインドはメインスレッドから行う。
         */

        /*
         SubjectはObservableとObserverの両方の役割を持つ。
         - PublishSubject: 購読開始後の値を通知する。
         - BehaviorSubject: 初期値または最新の値を、新しい購読者へ通知する。
         - ReplaySubject: 設定したバッファに保持している値を、新しい購読者へ再送する。
         - AsyncSubject: 正常完了時に最後の値を通知する。エラー終了時は値を通知しない。
         */

        /*
         Relayは値の受け渡しに限定したSubjectのラッパーで、完了やエラーを受け付けない。
         PublishRelayは購読開始後の値、BehaviorRelayは現在の値と以降の更新を通知する。
         */

        let os1 = Observable.just("e1")
        let disposeBag = DisposeBag()
        let _ = os1.asSingle()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        // result: e1

        let os2 = Observable.of("e1", "e2")
        let _ = os2.asSingle()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        // result: Sequence contains more than one element.

        Completable.empty()
            .subscribe(
                onCompleted: {
                    print("completed")
                },
                onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)

        let os3 = Observable.of("e2")
        os3.asMaybe()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                },
                onCompleted: {
                    print("completed")
                }
            )
            .disposed(by: disposeBag)

        let os4 = Observable<Any>.empty()
        os4.asMaybe()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                },
                onCompleted: {
                    print("completed")
                }
            )
            .disposed(by: disposeBag)

        let os5 = Observable.of("e3", "e4")
        os5.asDriver(onErrorJustReturn: "default")
            .drive(
                onNext: {
                    print($0)
                },
                onCompleted: {
                    print("driver completed")
                },
                onDisposed: {
                    print("driver disposed")
                }
            )
            .disposed(by: disposeBag)
    }
}
