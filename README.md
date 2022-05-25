# OrderedView

OrderedView lets you layout your screen in a nice declarative way.

```
        view = OrderedView<Vertical>(arrangedComponents: [
            .spacer(ofSize: .relational(percentOfParent: 7), isAdaptable: true),
            .view(segmentedControl,
                  withLayout: .init(vertical: .fixedSize(40),
                                    horizontal: .fixedOffset(64))),
            .spacer(ofSize: .fixedSize(32), isAdaptable: true),
            .view(pages,
                  withLayout: .init(vertical: .relational(percentOfParent: 50),
                                    horizontal: .anyButSmaller)),
            .spacer(ofSize: .fixedSize(40)),
            .view(controlPanel,
                  withLayout: .init(vertical: .relational(percentOfParent: 15),
                                    horizontal: .fixedSize(160))),
            .spacer(ofSize: .fixedSize(40), isAdaptable: true),
            .view(finishButton,
                  withLayout: .init(vertical: .fixedSize(64),
                                    horizontal: .relational(percentOfParent: 100)))
        ])
```
