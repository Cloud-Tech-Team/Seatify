# Generated by Django 5.0.1 on 2025-01-29 13:47

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Seatifyapp', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SeatingArrangementDataset',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('seating_data', models.JSONField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('arrangement', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Seatifyapp.seatingarrangement')),
            ],
        ),
    ]
