import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
import joblib

# Load dataset from JSON
df = pd.read_json("diabetes_dataset_1000.json")

# Convert label to numeric
df['label'] = df['label'].map({
    'Berisiko Diabetes': 1,
    'Tidak Berisiko Diabetes': 0
})

# Split features and label
X = df[['age', 'bmi', 'glucose', 'bp']]
y = df['label']

# Train/test split
X_train, _, y_train, _ = train_test_split(X, y, test_size=0.2, random_state=42)

# Train model
model = DecisionTreeClassifier()
model.fit(X_train, y_train)

# Save model
joblib.dump(model, 'decision_tree_model.pkl')
print(" Model trained and saved as decision_tree_model.pkl")
